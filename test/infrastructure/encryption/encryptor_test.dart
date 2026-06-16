/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2026 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/infrastructure/encryption/encryptor.dart';
import 'package:online_payments_sdk/src/infrastructure/interfaces/collected_device_information_provider.dart';
import 'package:online_payments_sdk/src/infrastructure/interfaces/jose_encryption_provider.dart';
import 'package:online_payments_sdk/src/infrastructure/models/collected_device_information.dart';

import '../../helpers/test_utils.dart';

// --- Helper ---

/// Converts a paymentValues list `[{key, value}, ...]` to a `{key: value}` map for easy assertion.
Map<String, String> _toValueMap(List<dynamic> paymentValues) {
  return {
    for (final entry in paymentValues.cast<Map<String, dynamic>>())
      entry['key'] as String: entry['value'] as String,
  };
}

// --- Test doubles ---

class _RecordingJoseProvider implements JoseEncryptionProvider {
  final List<Map<String, dynamic>> capturedPayloads = [];
  final List<PublicKeyResponse> capturedKeys = [];
  final String returnValue = 'mock.encrypted.value';

  _RecordingJoseProvider();

  @override
  String encrypt(Map<String, dynamic> plainText, PublicKeyResponse publicKeyResponse) {
    capturedPayloads.add(Map.unmodifiable(plainText));
    capturedKeys.add(publicKeyResponse);
    return returnValue;
  }
}

class _NullCollectedDeviceInformationProvider implements CollectedDeviceInformationProvider {
  @override
  CollectedDeviceInformation? getCollectedDeviceInformation() => null;
}

class _NonNullCollectedDeviceInformationProvider implements CollectedDeviceInformationProvider {
  final CollectedDeviceInformation value;

  _NonNullCollectedDeviceInformationProvider(this.value);

  @override
  CollectedDeviceInformation? getCollectedDeviceInformation() => value;
}


final _publicKey = PublicKeyResponse('test-kid', 'fake-key');

void main() {
  group('Encryptor.encrypt (PaymentRequest)', () {
    late PaymentProduct paymentProduct;
    late _RecordingJoseProvider joseProvider;
    late Encryptor encryptor;

    setUp(() {
      paymentProduct = createTestPaymentProduct();
      joseProvider = _RecordingJoseProvider();
      encryptor = Encryptor('test-session-id', joseProvider, _NullCollectedDeviceInformationProvider());
    });

    test('delegates to JoseEncryptionProvider with correct payload shape', () {
      final request = PaymentRequest(paymentProduct: paymentProduct);
      request.setValue('cardNumber', '4567350000427977');
      request.tokenize = true;

      final encrypted = encryptor.encrypt(_publicKey, request);

      expect(encrypted, equals('mock.encrypted.value'));
      expect(joseProvider.capturedPayloads, hasLength(1));
      expect(joseProvider.capturedKeys.first, same(_publicKey));

      final payload = joseProvider.capturedPayloads.first;
      expect(payload['clientSessionId'], equals('test-session-id'));
      expect(payload['paymentProductId'], equals(paymentProduct.id));
      expect(payload['tokenize'], isTrue);
      expect(payload['nonce'], matches(RegExp(r'^[0-9a-f]{32}$')));
      final paymentValues = _toValueMap(payload['paymentValues'] as List);
      expect(paymentValues['cardNumber'], equals('4567350000427977'));
    });

    test('includes accountOnFileId when account-on-file is set', () {
      final aof = createTestAccountOnFile(id: '1234', paymentProductId: paymentProduct.id ?? 3);
      final request = PaymentRequest(paymentProduct: paymentProduct, accountOnFile: aof);

      encryptor.encrypt(_publicKey, request);

      final payload = joseProvider.capturedPayloads.first;
      expect(payload['accountOnFileId'], equals('1234'));
    });

    test('does not include accountOnFileId when no account-on-file is set', () {
      final request = PaymentRequest(paymentProduct: paymentProduct);
      request.setValue('cardNumber', '4567350000427977');

      encryptor.encrypt(_publicKey, request);

      final payload = joseProvider.capturedPayloads.first;
      expect(payload, isNot(contains('accountOnFileId')));
    });

    test('includes collectedDeviceInformation when provider returns non-null', () {
      final deviceInfo = CollectedDeviceInformation(
        timezoneOffsetUtcMinutes: -60,
        locale: 'en-US',
        browserData: BrowserData(
          javaScriptEnabled: true,
          colorDepth: 24,
          screenHeight: 768,
          screenWidth: 1366,
          innerHeight: 600,
          innerWidth: 1200,
        ),
      );
      encryptor = Encryptor(
        'test-session-id',
        joseProvider,
        _NonNullCollectedDeviceInformationProvider(deviceInfo),
      );

      final request = PaymentRequest(paymentProduct: paymentProduct);
      encryptor.encrypt(_publicKey, request);

      final payload = joseProvider.capturedPayloads.first;
      expect(payload['collectedDeviceInformation'], isNotNull);
    });

    test('omits collectedDeviceInformation when provider returns null', () {
      final request = PaymentRequest(paymentProduct: paymentProduct);
      encryptor.encrypt(_publicKey, request);

      final payload = joseProvider.capturedPayloads.first;
      expect(payload, isNot(contains('collectedDeviceInformation')));
    });

    test('generates unique nonce on each call', () {
      final request = PaymentRequest(paymentProduct: paymentProduct);

      encryptor.encrypt(_publicKey, request);
      encryptor.encrypt(_publicKey, request);

      final nonce1 = joseProvider.capturedPayloads[0]['nonce'] as String;
      final nonce2 = joseProvider.capturedPayloads[1]['nonce'] as String;
      expect(nonce1, isNot(equals(nonce2)));
    });
  });

  group('Encryptor.encryptTokenRequest (CreditCardTokenRequest)', () {
    late _RecordingJoseProvider joseProvider;
    late Encryptor encryptor;

    setUp(() {
      joseProvider = _RecordingJoseProvider();
      encryptor = Encryptor('test-session-id', joseProvider, _NullCollectedDeviceInformationProvider());
    });

    test('delegates to JoseEncryptionProvider with correct payload shape', () {
      final tokenRequest = CreditCardTokenRequest();
      tokenRequest.setCardNumber('4242424242424242');
      tokenRequest.setPaymentProductId(1);

      final encrypted = encryptor.encryptTokenRequest(_publicKey, tokenRequest);

      expect(encrypted, equals('mock.encrypted.value'));
      expect(joseProvider.capturedPayloads, hasLength(1));

      final payload = joseProvider.capturedPayloads.first;
      expect(payload['clientSessionId'], equals('test-session-id'));
      expect(payload['paymentProductId'], equals(1));
      expect(payload['nonce'], matches(RegExp(r'^[0-9a-f]{32}$')));
      final paymentValues = _toValueMap(payload['paymentValues'] as List);
      expect(paymentValues['cardNumber'], equals('4242424242424242'));
      expect(paymentValues['paymentProductId'], equals('1'));
      // Only set fields should be included (null ones filtered out)
      expect((payload['paymentValues'] as List), hasLength(2));
    });

    test('keeps empty string values — only null is filtered out', () {
      final tokenRequest = CreditCardTokenRequest();
      tokenRequest.setCardNumber('4242424242424242');
      tokenRequest.setSecurityCode(''); // empty string must be kept
      tokenRequest.setPaymentProductId(1);

      encryptor.encryptTokenRequest(_publicKey, tokenRequest);

      final paymentValues = _toValueMap(joseProvider.capturedPayloads.first['paymentValues'] as List);
      expect(paymentValues['cardNumber'], equals('4242424242424242'));
      expect(paymentValues['cvv'], equals(''));
      expect(paymentValues['paymentProductId'], equals('1'));
      expect((joseProvider.capturedPayloads.first['paymentValues'] as List), hasLength(3));
    });

    test('throws EncryptionError when paymentProductId is missing', () {
      final tokenRequest = CreditCardTokenRequest();
      tokenRequest.setCardNumber('4242424242424242');

      expect(
        () => encryptor.encryptTokenRequest(_publicKey, tokenRequest),
        throwsA(
          isA<EncryptionError>().having(
            (error) => error.message,
            'message',
            contains('the payment product ID is not set'),
          ),
        ),
      );
    });
  });
}
