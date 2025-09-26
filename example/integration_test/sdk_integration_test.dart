/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2025 Worldline and/or its affiliates.
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

/// Integration tests that verify the Flutter SDK works correctly with real native SDKs.
/// These tests will catch breaking changes in:
/// - Native SDK API signatures
/// - Data structure changes (missing/renamed properties)
/// - Business logic changes in validation, masking, etc.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await TestCredentials.get();
  });

  group('SDK Integration Tests', () {
    late Session session;

    setUpAll(() async {
      session = Session(
        TestCredentials.clientSessionId,
        TestCredentials.customerId,
        TestCredentials.clientApiUrl,
        TestCredentials.assetUrl,
        appIdentifier: "FlutterSDKIntegrationTest/2.0.0",
        loggingEnabled: true,
      );
      // Wait a bit for the native SDK to initialize
      await Future.delayed(const Duration(milliseconds: 500));
    });

    group('Session API Tests', () {
      testWidgets('getPaymentProduct - invalid product ID', (WidgetTester tester) async {
        bool testCompleted = false;
        String? errorMessage;

        final request = PaymentProductRequest(
          productId: "99999",
          paymentContext: TestHelpers.createTestPaymentContext(),
        );

        await session.getPaymentProduct(
          request: request,
          listener: PaymentProductResponseListener(
            onSuccess: (PaymentProduct product) {
              // Should not succeed with invalid product ID
              errorMessage = "Expected error but got success with product: ${product.id}";
              testCompleted = true;
            },
            onError: (ErrorResponse? apiError) {
              // This is expected for invalid product ID
              expect(apiError, isNotNull);
              expect(apiError!.message, isNotNull);
              testCompleted = true;
            },
            onException: (NativeException? throwable) {
              // This is also acceptable for invalid product ID
              expect(throwable, isNotNull);
              expect(throwable!.error, isNotNull);
              testCompleted = true;
            },
          ),
        );

        expect(testCompleted, true, reason: "Test should complete");
        expect(errorMessage, isNull, reason: errorMessage ?? "");
      });

      testWidgets('getIinDetails - unknown card number', (WidgetTester tester) async {
        bool testCompleted = false;
        String? errorMessage;

        final request = IinDetailsRequest(
          partialCreditCardNumber: "999999",
          paymentContext: TestHelpers.createTestPaymentContext(),
        );

        await session.getIinDetails(
          request: request,
          listener: IinLookupResponseListener(
            onSuccess: (IinDetailsResponse response) {
              expect(response, isNotNull);
              expect(response.status, equals(IinStatus.unknown));
              testCompleted = true;
            },
            onError: (ErrorResponse? apiError) {
              errorMessage = "API Error: ${apiError?.message}";
              testCompleted = true;
            },
            onException: (NativeException? throwable) {
              errorMessage = "API Error: ${throwable?.error}";
              testCompleted = true;
            },
          ),
        );

        expect(testCompleted, true, reason: "Test should complete");
        expect(errorMessage, isNull, reason: errorMessage ?? "");
      });
      testWidgets('getPublicKey', (WidgetTester tester) async {
        bool testCompleted = false;
        String? errorMessage;

        await session.getPublicKey(
          listener: PublicKeyResponseListener(
            onSuccess: (PublicKey publicKey) {
              expect(publicKey.keyId, isA<String>());
              expect(publicKey.publicKey, isA<String>());
              expect(publicKey.publicKey.isNotEmpty, true);
              testCompleted = true;
            },
            onError: (ErrorResponse? apiError) {
              errorMessage = "API Error: ${apiError?.message}";
              testCompleted = true;
            },
            onException: (NativeException? throwable) {
              errorMessage = "Exception: ${throwable?.error}";
              testCompleted = true;
            },
          ),
        );

        expect(testCompleted, true, reason: "Test should complete");
        expect(errorMessage, isNull, reason: errorMessage ?? "");
      });

      testWidgets('getBasicPaymentProducts', (WidgetTester tester) async {
        final request = BasicPaymentProductsRequest(
          paymentContext: TestHelpers.createTestPaymentContext(),
        );

        final products = await TestHelpers.executeWithListener<BasicPaymentProducts>(
          testName: "getBasicPaymentProducts",
          sdkCall: (listener) => session.getBasicPaymentProducts(
            request: request,
            listener: listener,
          ),
          extractResult: (result) => result as BasicPaymentProducts,
          createListener: ({
            required onSuccess,
            required onError,
            required onException,
          }) =>
              BasicPaymentProductsResponseListener(
            onSuccess: onSuccess,
            onError: onError,
            onException: onException,
          ),
        );

        // Verify response structure hasn't changed
        expect(products.basicPaymentProducts, isA<List<BasicPaymentProduct>>());
        expect(products.basicPaymentProducts.isNotEmpty, true);

        // Verify BasicPaymentProduct structure
        final firstProduct = products.basicPaymentProducts.first;
        expect(firstProduct.id, isA<String>());
        expect(firstProduct.paymentMethod, isA<String>());
        expect(firstProduct.displayHintsList, isA<List<PaymentProductDisplayHints>>());
      });

      testWidgets('getPaymentProduct - should handle detailed product response structure', (WidgetTester tester) async {
        final product = await TestHelpers.getPaymentProduct(session, '1');

        // Verify detailed product structure
        expect(product!.id, equals("1"));
        expect(product.fields, isA<List<PaymentProductField>>());
        expect(product.displayHintsList, isA<List<PaymentProductDisplayHints>>());

        // Verify field structure hasn't changed
        if (product.fields.isNotEmpty) {
          final firstField = product.fields.first;
          expect(firstField.id, isA<String>());
          expect(firstField.type, isA<PaymentProductFieldType>());
          expect(firstField.displayHints, isA<PaymentProductFieldDisplayHints>());
          expect(firstField.dataRestrictions, isA<DataRestrictions>());
        }
      });

      testWidgets('getPaymentProduct - get product without all known field', (WidgetTester tester) async {
        final product = await TestHelpers.getPaymentProduct(session, '132');

        // Verify detailed product structure
        expect(product!.id, equals("132"));
        expect(product.fields, isA<List<PaymentProductField>>());
      });

      testWidgets('getIinDetails - should handle IIN lookup response structure', (WidgetTester tester) async {
        bool testCompleted = false;
        String? errorMessage;

        final request = IinDetailsRequest(
            partialCreditCardNumber: "401200", // Test Visa BIN
            paymentContext: TestHelpers.createTestPaymentContext());

        await session.getIinDetails(
          request: request,
          listener: IinLookupResponseListener(
            onSuccess: (IinDetailsResponse response) {
              // Verify IIN response structure
              expect(response.paymentProductId, isA<String?>());
              expect(response.countryCode, isA<String?>());
              expect(response.isAllowedInContext, isA<bool?>());
              expect(response.coBrands, isA<List<IinDetail>?>());

              testCompleted = true;
            },
            onError: (ErrorResponse? apiError) {
              errorMessage = "API Error: ${apiError?.message}";
              testCompleted = true;
            },
            onException: (NativeException? throwable) {
              errorMessage = "Exception: ${throwable?.error}";
              testCompleted = true;
            },
          ),
        );

        expect(testCompleted, true, reason: "Test should complete");
        expect(errorMessage, isNull, reason: errorMessage ?? "");
      });
    });

    group('Validation Integration Tests', () {
      testWidgets('empty request validation', (WidgetTester tester) async {
        final paymentProduct = await TestHelpers.getPaymentProduct(session, "1");

        // Test that empty request has validation errors for required fields
        final emptyRequest = PaymentRequest(paymentProduct: paymentProduct!);
        var validationResult = await emptyRequest.validate();
        TestHelpers.expectRequiredFieldValidationErrors(validationResult, paymentProduct);
      });

      testWidgets('valid request validation', (WidgetTester tester) async {
        final paymentProduct = await TestHelpers.getPaymentProduct(session, "1");
        final paymentRequest = TestHelpers.createTestPaymentRequest(paymentProduct!);
        final validationResult = await paymentRequest.validate();

        TestHelpers.expectNoValidationErrors(validationResult);
      });

      testWidgets('invalid payment request validation', (WidgetTester tester) async {
        final paymentProduct = await TestHelpers.getPaymentProduct(session, "1");
        final invalidRequest = PaymentRequest(paymentProduct: paymentProduct!);

        // Set invalid values for all fields
        invalidRequest.setValue('cardNumber', '1234'); // Too short
        invalidRequest.setValue('expiryDate', '1320'); // Invalid month
        invalidRequest.setValue('cvv', 'asdf'); // Invalid regex
        invalidRequest.setValue('cardholderName', ''); // Empty (if required)

        final validationResult = await invalidRequest.validate();
        TestHelpers.expectValidationErrors(validationResult);

        // Should have multiple validation errors
        // luhn + length for card number, regex + exp date for expiration date, required for cardholder and cvv
        expect(validationResult.length, equals(6),
            reason: "Multiple invalid fields should produce multiple errors");
      });

      testWidgets('valid product field validation', (WidgetTester tester) async {
        final paymentProduct = await TestHelpers.getPaymentProduct(session, "1");
        final values = TestHelpers.createTestFieldValues(paymentProduct!);

        // Test individual field validation with valid values
        for (var field in paymentProduct.fields) {
          var validationResult = await field.validateValue(values[field.id]!, paymentProduct);
          if (field.dataRestrictions.isRequired) {
            TestHelpers.expectNoValidationErrors(validationResult);
          }
        }
      });

      testWidgets('invalid credit card validation', (WidgetTester tester) async {
        final paymentProduct = await TestHelpers.getPaymentProduct(session, "1");

        // Test individual field validation with invalid values
        final cardNumberField = paymentProduct!.fields.singleWhere((f) => f.id == 'cardNumber');
        var validationResult = await cardNumberField.validateValue('invalid value', paymentProduct);
        TestHelpers.expectValidationErrors(validationResult);
      });

      testWidgets('individual field validation errors', (WidgetTester tester) async {
        final paymentProduct = await TestHelpers.getPaymentProduct(session, "1");

        // Test various invalid values for different field types
        final testCases = {
          'cardNumber': ['123', 'abcd', '1234567890123456'], // Too short, non-numeric, invalid luhn
          'expiryDate': ['1399', '0025', 'abcd'], // Invalid month, past date, non-numeric
          'cvv': ['abc', ''], // non-numeric, empty
        };

        for (final fieldId in testCases.keys) {
          final field = paymentProduct!.fields.singleWhere((f) => f.id == fieldId);

          for (final invalidValue in testCases[fieldId]!) {
            final validationResult = await field.validateValue(invalidValue, paymentProduct);

            if (field.dataRestrictions.isRequired || invalidValue.isNotEmpty) {
              // Should have validation errors for invalid values
              expect(validationResult.length, greaterThan(0),
                  reason: "Field '$fieldId' with value '$invalidValue' should have validation errors");
            }
          }
        }
      });
    });

    group('Masking Integration Tests', () {
      testWidgets('field masking', (WidgetTester tester) async {
        final paymentProduct = await TestHelpers.getPaymentProduct(session, "1");

        // Find the card number field for masking tests
        final cardNumberField = paymentProduct!.fields.firstWhere(
          (field) => field.id == "cardNumber",
          orElse: () => throw Exception('No cardNumber field found'),
        );

        // Test masking with partial card number
        var maskedValue = await cardNumberField.applyMask("1234567");
        expect(maskedValue, isA<String>());
        expect(maskedValue, equals("1234 567"));

        // Test masking with full card number
        maskedValue = await cardNumberField.applyMask("1234567890123456");
        expect(maskedValue, isA<String>());
        expect(maskedValue.trim(), equals("1234 5678 9012 3456"));
      });
    });
  });
}
