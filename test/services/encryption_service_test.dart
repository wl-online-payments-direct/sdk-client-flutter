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

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/infrastructure/encryption/encryptor.dart';
import 'package:online_payments_sdk/src/infrastructure/interfaces/collected_device_information_provider.dart';
import 'package:online_payments_sdk/src/infrastructure/interfaces/device_information_provider.dart';
import 'package:online_payments_sdk/src/infrastructure/interfaces/jose_encryption_provider.dart';
import 'package:online_payments_sdk/src/infrastructure/models/collected_device_information.dart';
import 'package:online_payments_sdk/src/infrastructure/models/metadata.dart';
import 'package:online_payments_sdk/src/infrastructure/utils/cache_manager.dart';
import 'package:online_payments_sdk/src/services/default_encryption_service.dart';

import '../helpers/test_api_client.dart';
import '../helpers/test_utils.dart';

class _FakeDeviceInformationProvider implements DeviceInformationProvider {
  @override
  Metadata getMetadata() {
    return const Metadata(
      screenSize: '1080x1920',
      platformIdentifier: 'test-platform',
      sdkIdentifier: 'test-sdk',
      sdkCreator: 'test-creator',
      appIdentifier: '',
      deviceBrand: 'Apple',
      deviceType: 'iPhone',
    );
  }
}

class _FakeCollectedDeviceInformationProvider implements CollectedDeviceInformationProvider {
  @override
  CollectedDeviceInformation? getCollectedDeviceInformation() => null;
}

class _FakeJoseEncryptionProvider implements JoseEncryptionProvider {
  @override
  String encrypt(Map<String, dynamic> plainText, PublicKeyResponse publicKeyResponse) {
    return base64Url.encode(utf8.encode(jsonEncode({'keyId': publicKeyResponse.keyId, 'payload': plainText})));
  }
}

class _SpyEncryptor extends Encryptor {
  bool encryptCalled = false;
  bool encryptTokenCalled = false;

  _SpyEncryptor() : super('test-session-id', _FakeJoseEncryptionProvider(), _FakeCollectedDeviceInformationProvider());

  @override
  String encrypt(PublicKeyResponse publicKey, PaymentRequest request) {
    encryptCalled = true;

    return super.encrypt(publicKey, request);
  }

  @override
  String encryptTokenRequest(PublicKeyResponse publicKey, CreditCardTokenRequest request) {
    encryptTokenCalled = true;

    return super.encryptTokenRequest(publicKey, request);
  }
}

void main() {
  late TestApiClient apiClient;
  late DefaultEncryptionService service;

  setUp(() {
    apiClient = TestApiClient();
    apiClient.setMockGet((_) async => successResponse(loadFixture('public_key_response.json')));
    service = DefaultEncryptionService(
      Encryptor('test-session-id', _FakeJoseEncryptionProvider(), _FakeCollectedDeviceInformationProvider()),
      _FakeDeviceInformationProvider(),
      null,
      CacheManager(),
      apiClient,
    );
  });

  group('DefaultEncryptionService', () {
    test('throws InvalidArgumentError for an invalid payment request', () {
      final request = PaymentRequest(paymentProduct: createTestPaymentProduct(cardholderNameRequired: false));

      expect(
        service.encryptPaymentRequest(request),
        throwsA(
          isA<InvalidArgumentError>()
              .having((error) => error.message, 'message', 'The payment request is not valid.')
              .having((error) => error.metadata, 'metadata', isA<ValidationResult>()),
        ),
      );
    });

    test('returns an EncryptedRequest for a valid payment request', () async {
      final request = PaymentRequest(paymentProduct: createTestPaymentProduct(cardholderNameRequired: false));
      request.setValue('cardNumber', '4242424242424242');
      request.setValue('expiryDate', '12/26');
      request.setValue('cvv', '123');

      final encryptedRequest = await service.encryptPaymentRequest(request);

      expect(encryptedRequest, isA<EncryptedRequest>());
      expect(encryptedRequest.encryptedCustomerInput, isNotEmpty);
      expect(encryptedRequest.encodedClientMetaInfo, isNotEmpty);
    });

    test('getPublicKey_WhenNotCached_FetchesFromApiAndStoresInCache', () async {
      var callCount = 0;
      apiClient.setMockGet((_) async {
        callCount++;

        return successResponse(loadFixture('public_key_response.json'));
      });

      final result = await service.getPublicKey();

      expect(callCount, equals(1));
      expect(result, isA<PublicKeyResponse>());
      expect(result.keyId, isNotEmpty);

      await service.getPublicKey();
      expect(callCount, equals(1));
    });

    test('getPublicKey_WhenApiResponseIsInvalid_ThrowsResponseError', () {
      apiClient.setMockGet((_) async => errorResponse({}));

      expect(
        service.getPublicKey(),
        throwsA(
          isA<ResponseError>()
              .having((error) => error.message, 'message', 'Error while trying to fetch the public key.'),
        ),
      );
    });

    test('encryptPaymentRequest_WhenEncryptionSucceeds_ReturnsEncodedClientMetaInfo', () async {
      final request = PaymentRequest(paymentProduct: createTestPaymentProduct(cardholderNameRequired: false));
      request.setValue('cardNumber', '4242424242424242');
      request.setValue('expiryDate', '12/26');
      request.setValue('cvv', '123');

      final result = await service.encryptPaymentRequest(request);

      expect(result.encodedClientMetaInfo, isNotEmpty);
    });

    test('encryptPaymentRequest_UsesEncryptPath_NotTokenRequestPath', () async {
      final spyEncryptor = _SpyEncryptor();
      final serviceWithSpy = DefaultEncryptionService(
        spyEncryptor,
        _FakeDeviceInformationProvider(),
        null,
        CacheManager(),
        apiClient,
      );
      final request = PaymentRequest(paymentProduct: createTestPaymentProduct(cardholderNameRequired: false));
      request.setValue('cardNumber', '4242424242424242');
      request.setValue('expiryDate', '12/26');
      request.setValue('cvv', '123');

      await serviceWithSpy.encryptPaymentRequest(request);

      expect(spyEncryptor.encryptCalled, isTrue);
      expect(spyEncryptor.encryptTokenCalled, isFalse);
    });

    test('encryptTokenRequest_WhenTokenRequestIsValid_ReturnsEncryptedResult', () async {
      final tokenRequest = CreditCardTokenRequest()
        ..setPaymentProductId(1)
        ..setCardNumber('4242424242424242')
        ..setSecurityCode('123');

      final result = await service.encryptTokenRequest(tokenRequest);

      expect(result.encryptedCustomerInput, isNotEmpty);
      expect(result.encodedClientMetaInfo, isNotEmpty);
    });

    test('encryptTokenRequest_UsesEncryptTokenRequestPath_NotEncryptPath', () async {
      final spyEncryptor = _SpyEncryptor();
      final serviceWithSpy = DefaultEncryptionService(
        spyEncryptor,
        _FakeDeviceInformationProvider(),
        null,
        CacheManager(),
        apiClient,
      );
      final tokenRequest = CreditCardTokenRequest()
        ..setPaymentProductId(1)
        ..setCardNumber('4242424242424242')
        ..setSecurityCode('123');

      await serviceWithSpy.encryptTokenRequest(tokenRequest);

      expect(spyEncryptor.encryptTokenCalled, isTrue);
      expect(spyEncryptor.encryptCalled, isFalse);
    });
  });
}
