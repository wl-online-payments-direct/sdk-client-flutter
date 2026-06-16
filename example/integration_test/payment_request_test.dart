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
import 'package:integration_test/integration_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';


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

    test('validate_EmptyRequest_HasValidationErrorsForAllRequiredFields', () async {
      final product = await TestHelpers.getPaymentProduct(sdk, 1);
      final emptyRequest = PaymentRequest(paymentProduct: product);
      final result = emptyRequest.validate();
      TestHelpers.expectRequiredFieldValidationErrors(result, product);
    });

    test('validate_ValidRequest_HasNoValidationErrors', () async {
      final product = await TestHelpers.getPaymentProduct(sdk, 1);
      final request = TestHelpers.createTestPaymentRequest(product);
      final result = request.validate();
      TestHelpers.expectNoValidationErrors(result);
    });

    test('validate_WithInvalidValues_ProducesMultipleValidationErrors', () async {
      final product = await TestHelpers.getPaymentProduct(sdk, 1);
      final request = PaymentRequest(paymentProduct: product);

      request.setValue('cardNumber', '1234');     // Too short + invalid Luhn
      request.setValue('expiryDate', '1320');     // Invalid month
      request.setValue('cvv', 'asdf');            // Non-numeric
      request.setValue('cardholderName', '');     // Empty required

      final result = request.validate();
      TestHelpers.expectValidationErrors(result);
      // luhn + length for card, regex + expDate for date, required for cardholder and cvv
      expect(result.errorMessages.length, greaterThanOrEqualTo(4));
    });

    test('validate_WithValidIndividualFieldValues_HasNoValidationErrors', () async {
      final product = await TestHelpers.getPaymentProduct(sdk, 1);
      final values = TestHelpers.createTestFieldValues(product);

      for (final field in product.fields) {
        final value = values[field.id];
        if (value != null && field.dataRestrictions.isRequired) {
          final errors = field.validate(value);
          expect(errors, isEmpty, reason: "Field '${field.id}' with valid value should have no errors");
        }
      }
    });

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

    test('removeMask_RestoresOriginalUnmaskedValue', () async {
      final product = await TestHelpers.getPaymentProduct(sdk, 1);
      final cardNumberField = product.fields.firstWhere((f) => f.id == 'cardNumber');

      const original = '1234567890123456';
      final masked = cardNumberField.applyMask(original);
      expect(masked, isNotNull);

      final unmasked = cardNumberField.removeMask(masked!);
      expect(unmasked, equals(original));
    });
  });

  // ---------------------------------------------------------------------------
  // encryptPaymentRequest
  // ---------------------------------------------------------------------------

  group('sdk.encryptPaymentRequest', () {
    late OnlinePaymentSdk sdk;

    setUp(() => sdk = TestHelpers.createSdk());
    tearDown(() => sdk.dispose());

    test('encryptPaymentRequest_WhenMandatoryFieldNotSet_ThrowsSdkError', () async {
      final product = await TestHelpers.getPaymentProduct(sdk, 1);
      final request = PaymentRequest(paymentProduct: product);

      // Set all except cardNumber
      request.setValue('cardholderName', 'Test User');
      request.setValue('cvv', '123');
      request.setValue('expiryDate', '1228');

      await expectLater(
        () => sdk.encryptPaymentRequest(request),
        throwsA(isA<SdkError>()),
      );
    });

    test('encryptPaymentRequest_WithTokenizeFlag_SucceedsAndProducesEncryptedOutput', () async {
      final product = await TestHelpers.getPaymentProduct(sdk, 1);
      final request = TestHelpers.createTestPaymentRequest(product);
      request.tokenize = true;

      final result = await sdk.encryptPaymentRequest(request);

      expect(result.encryptedCustomerInput, isNotEmpty);
      expect(result.encodedClientMetaInfo, isNotEmpty);
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
