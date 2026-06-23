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
import 'package:integration_test/integration_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/infrastructure/encryption/encryptor.dart';
import 'package:online_payments_sdk/src/infrastructure/interfaces/collected_device_information_provider.dart';
import 'package:online_payments_sdk/src/infrastructure/interfaces/jose_encryption_provider.dart';
import 'package:online_payments_sdk/src/infrastructure/models/collected_device_information.dart';

import 'test_credentials.dart';
import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await TestCredentials.get();
  });

  // ---------------------------------------------------------------------------
  // Validation
  // ---------------------------------------------------------------------------

  group('Validation', () {
    late OnlinePaymentSdk sdk;

    setUp(() => sdk = TestHelpers.createSdk());
    tearDown(() => sdk.dispose());

    test('validate_WithInvalidCardNumber_ProducesValidationErrors', () async {
      final product = await TestHelpers.getPaymentProduct(sdk, 1);
      final cardNumberField = product.fields.firstWhere((f) => f.id == 'cardNumber');
      final errors = cardNumberField.validate('invalid value');
      expect(errors, isNotEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // Masking
  // ---------------------------------------------------------------------------

  group('Masking', () {
    late OnlinePaymentSdk sdk;

    setUp(() => sdk = TestHelpers.createSdk());
    tearDown(() => sdk.dispose());

    test('applyMask_ProducesCorrectlyFormattedOutput', () async {
      final product = await TestHelpers.getPaymentProduct(sdk, 1);
      final cardNumberField = product.fields.firstWhere((f) => f.id == 'cardNumber');

      final masked = cardNumberField.applyMask('1234567');
      expect(masked, isA<String?>());
      expect(masked, equals('1234 567'));

      final fullyMasked = cardNumberField.applyMask('1234567890123456');
      expect(fullyMasked?.trim(), equals('1234 5678 9012 3456'));
    });
  });

  // ---------------------------------------------------------------------------
  // encryptPaymentRequest
  // ---------------------------------------------------------------------------

  group('sdk.encryptPaymentRequest', () {
    late OnlinePaymentSdk sdk;

    setUp(() => sdk = TestHelpers.createSdk());
    tearDown(() => sdk.dispose());

    test('encryptPaymentRequest_WhenMandatoryFieldNotSet_ThrowsSdkErrorAndDoesNotCallPublicKeyApi', () async {
      final product = await TestHelpers.getPaymentProduct(sdk, 1);
      final (countingSdk, counter) = createSdkWithCounter();
      addTearDown(countingSdk.dispose);

      final request = PaymentRequest(paymentProduct: product);

      // Set all except cardNumber
      request.setValue('cardholderName', 'Test User');
      request.setValue('cvv', '123');
      request.setValue('expiryDate', '1228');

      await expectLater(
            () => countingSdk.encryptPaymentRequest(request),
        throwsA(isA<SdkError>()),
      );

      expect(counter.callCount, equals(0));
    });

    test('encryptPaymentRequest_WithValidRequest_ReturnsEncryptedOutputAsJweCompactSerialization', () async {
      final product = await TestHelpers.getPaymentProduct(sdk, 1);
      final request = TestHelpers.createTestPaymentRequest(product);

      final result = await sdk.encryptPaymentRequest(request);

      expect(result.encryptedCustomerInput, isNotEmpty);
      expect(result.encryptedCustomerInput, isA<String>());
      expect(result.encryptedCustomerInput.split('.'), hasLength(5));
    });

    test('encryptPaymentRequest_WithTokenizeFlag_SucceedsAndProducesEncryptedOutput', () async {
      final product = await TestHelpers.getPaymentProduct(sdk, 1);
      final request = TestHelpers.createTestPaymentRequest(product);
      request.tokenize = true;

      final result = await sdk.encryptPaymentRequest(request);

      expect(result.encryptedCustomerInput, isNotEmpty);
      expect(result.encryptedCustomerInput.split('.'), hasLength(5));
      expect(result.encodedClientMetaInfo, isNotEmpty);
    });

    test('encryptPaymentRequest_WithTokenizeFlag_BuildsPayloadWithTokenizeTrue', () async {
      final product = await TestHelpers.getPaymentProduct(sdk, 1);
      final request = TestHelpers.createTestPaymentRequest(product);
      request.tokenize = true;

      final encryptionProvider = _CapturingJoseEncryptionProvider();
      final encryptor = Encryptor(
        TestCredentials.createSessionData().clientSessionId,
        encryptionProvider,
        _NullCollectedDeviceInformationProvider(),
      );

      final encrypted = encryptor.encrypt(PublicKeyResponse('key-id', 'public-key'), request);

      expect(encrypted, equals('captured-encrypted-output'));

      final plainText = encryptionProvider.plainText;
      expect(plainText, isNotNull);
      expect(plainText?['clientSessionId'], equals(TestCredentials.createSessionData().clientSessionId));
      expect(plainText?['paymentProductId'], equals(1));
      expect(plainText?['tokenize'], isTrue);
      expect(plainText?['paymentValues'], isA<List<Map<String, String>>>());
      expect(
        plainText?['paymentValues'],
        containsAll([
          {'key': 'cardNumber', 'value': '4330264936344675'},
          {'key': 'cvv', 'value': '123'},
          {'key': 'cardholderName', 'value': 'John Doe'},
        ]),
      );
    });

    test('encryptPaymentRequest_ReturnsEncodedClientMetaInformation', () async {
      final product = await TestHelpers.getPaymentProduct(sdk, 1);
      final request = TestHelpers.createTestPaymentRequest(product);

      final result = await sdk.encryptPaymentRequest(request);

      expect(result.encodedClientMetaInfo, isNotNull);
      expect(result.encodedClientMetaInfo, isNotEmpty);

      final decodedMetadata = jsonDecode(_decodeBase64Url(result.encodedClientMetaInfo!)) as Map<String, dynamic>;

      expect(decodedMetadata['screenSize'], isA<String>());
      expect(decodedMetadata['platformIdentifier'], isA<String>());
      expect(decodedMetadata['sdkIdentifier'], isA<String>());
      expect(decodedMetadata['sdkCreator'], isA<String>());
      expect(decodedMetadata['appIdentifier'], equals('FlutterSDKIntegrationTest/2.0.0'));
      expect(decodedMetadata['deviceBrand'], isA<String>());
      expect(decodedMetadata['deviceType'], isA<String>());
    });

    test('encryptPaymentRequest_MultipleRequests_ProduceDifferentEncryptedOutputs', () async {
      final product = await TestHelpers.getPaymentProduct(sdk, 1);
      final request1 = TestHelpers.createTestPaymentRequest(product);
      final request2 = TestHelpers.createTestPaymentRequest(product);

      final result1 = await sdk.encryptPaymentRequest(request1);
      final result2 = await sdk.encryptPaymentRequest(request2);

      expect(result1.encryptedCustomerInput, isNot(equals(result2.encryptedCustomerInput)));
    });

    test('encryptPaymentRequest_WithInvalidCardNumber_ThrowsSdkErrorWithLuhnValidationError', () async {
      final product = await TestHelpers.getPaymentProduct(sdk, 1);
      final request = PaymentRequest(paymentProduct: product);
      request.setValue('cardNumber', '4222422242224222'); // fails Luhn
      request.setValue('cardholderName', 'Test User');
      request.setValue('cvv', '123');
      request.setValue('expiryDate', TestHelpers.createTestFieldValues(product)['expiryDate']!);

      try {
        await sdk.encryptPaymentRequest(request);
        fail('Should have thrown SdkError');
      } catch (error) {
        expect(error, isA<InvalidArgumentError>());
        final validationResult = (error as InvalidArgumentError).metadata as ValidationResult;
        expect(
          validationResult.errorMessages.any((m) => m.rule?.type == ValidationRuleType.luhn),
          isTrue,
        );
      }
    });

    test('encryptPaymentRequest_WithAccountOnFile_SucceedsWithOnlyCvvProvided', () async {
      final product = await TestHelpers.getPaymentProduct(sdk, 1);
      final expiryDate = TestHelpers.createTestFieldValues(product)['expiryDate']!;
      final aof = AccountOnFile(
        '0',
        1,
        attributes: [
          AccountOnFileAttribute(
            key: 'cardNumber',
            value: '4330264936344675',
            status: AccountOnFileAttributeStatus.readOnly,
          ),
          AccountOnFileAttribute(
            key: 'cardholderName',
            value: 'Test User',
            status: AccountOnFileAttributeStatus.readOnly,
          ),
          AccountOnFileAttribute(
            key: 'expiryDate',
            value: expiryDate,
            status: AccountOnFileAttributeStatus.readOnly,
          ),
        ],
      );
      final request = PaymentRequest(paymentProduct: product, accountOnFile: aof);
      request.setValue('cvv', '123');

      final result = await sdk.encryptPaymentRequest(request);

      expect(result.encryptedCustomerInput, isNotEmpty);
      expect(result.encryptedCustomerInput.split('.'), hasLength(5));
    });

    test('paymentRequest_WhenAccountOnFileIsPresent_ReadOnlyCardNumberCannotBeWritten', () async {
      final product = await TestHelpers.getPaymentProduct(sdk, 1);
      final aof = AccountOnFile(
        '0',
        1,
        attributes: [
          AccountOnFileAttribute(
            key: 'cardNumber',
            value: '4330264936344675',
            status: AccountOnFileAttributeStatus.readOnly,
          ),
        ],
      );
      final request = PaymentRequest(paymentProduct: product, accountOnFile: aof);

      expect(
            () => request.setValue('cardNumber', '4222422242224222'),
        throwsA(isA<InvalidArgumentError>()),
      );
    });
  });
}

String _decodeBase64Url(String value) {
  return utf8.decode(base64Url.decode(base64Url.normalize(value)));
}

class _CapturingJoseEncryptionProvider implements JoseEncryptionProvider {
  Map<String, dynamic>? plainText;

  @override
  String encrypt(Map<String, dynamic> plainText, PublicKeyResponse publicKeyResponse) {
    this.plainText = plainText;
    return 'captured-encrypted-output';
  }
}

class _NullCollectedDeviceInformationProvider implements CollectedDeviceInformationProvider {
  @override
  CollectedDeviceInformation? getCollectedDeviceInformation() => null;
}