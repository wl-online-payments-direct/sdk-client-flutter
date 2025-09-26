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
import 'package:online_payments_sdk/online_payments_sdk.dart';

class TestHelpers {
  /// Creates a standard PaymentProductRequest.
  static PaymentProductRequest createTestPaymentProductRequest(
    String productId, PaymentContext paymentContext) {
    return PaymentProductRequest(
      productId: productId,
      paymentContext: paymentContext,
    );
  }

  /// Creates a standard PaymentContext for testing with EUR currency and Netherlands locale.
  static PaymentContext createTestPaymentContext({
    int amountInCents = 1000,
    String currencyCode = "EUR",
    String countryCode = "NL",
    bool isRecurring = false,
  }) {
    return PaymentContext(
      AmountOfMoney(amountInCents, currencyCode),
      countryCode,
      isRecurring,
    );
  }

  /// Fetches a payment product and returns it via callback.
  static Future<PaymentProduct?> getPaymentProduct(
    Session session,
    String productId, {
    PaymentContext? paymentContext,
  }) async {
    PaymentProduct? paymentProduct;
    bool completed = false;
    String? errorMessage;

    final request = createTestPaymentProductRequest(
      productId,
      paymentContext ?? createTestPaymentContext(),
    );

    await session.getPaymentProduct(
      request: request,
      listener: PaymentProductResponseListener(
        onSuccess: (PaymentProduct product) {
          paymentProduct = product;
          completed = true;
        },
        onError: (ErrorResponse? apiError) {
          errorMessage = "API Error: ${apiError?.message}";
          completed = true;
        },
        onException: (NativeException? throwable) {
          errorMessage = "Exception: ${throwable?.error}";
          completed = true;
        },
      ),
    );

    expect(completed, true, reason: "Should complete product retrieval");
    expect(errorMessage, isNull, reason: "Should not throw an exception");
    expect(paymentProduct, isNotNull, reason: "Should retrieve payment product");

    return paymentProduct;
  }

  /// Creates a PaymentRequest with test credit card values.
  /// Automatically detects the correct expiry date format based on the field mask.
  static PaymentRequest createTestPaymentRequest(PaymentProduct paymentProduct) {
    final paymentRequest = PaymentRequest(paymentProduct: paymentProduct);

    createTestFieldValues(paymentProduct).forEach((key, value) {
      paymentRequest.setValue(key, value);
    });

    return paymentRequest;
  }

  /// Creates test field values map for validation testing.
  /// Automatically detects the correct expiry date format.
  static Map<String, String> createTestFieldValues(PaymentProduct paymentProduct) {
    return {
      'cardNumber': '4330264936344675',
      'expiryDate': _getExpiryDateForMask(paymentProduct),
      'cvv': '123',
      'cardholderName': 'John Doe',
    };
  }

  /// Validates that all required fields have validation errors when empty.
  static void expectRequiredFieldValidationErrors(
    List<ValidationErrorMessage> validationResult,
    PaymentProduct paymentProduct,
  ) {
    for (var field in paymentProduct.fields) {
      if (field.dataRestrictions.isRequired) {
        expect(
          validationResult.singleWhere((rule) {
            return rule.paymentProductFieldId == field.id;
          }),
          isNotNull,
          reason: "Required field '${field.id}' should have validation error when empty",
        );
      }
    }
  }

  /// Validates that a completed payment request has no validation errors.
  static void expectNoValidationErrors(List<ValidationErrorMessage> validationResult) {
    expect(
      validationResult.length,
      isZero,
      reason: "Valid payment request should have no validation errors",
    );
  }

  /// Validates that a completed payment request has validation errors.
  static void expectValidationErrors(List<ValidationErrorMessage> validationResult) {
    expect(
      validationResult.length,
      isNonZero,
      reason: "Invalid payment request should have validation errors",
    );
  }

  /// Generic helper to execute SDK calls that use callback listeners.
  /// Returns the result or throws an exception if the call fails.
  static Future<T> executeWithListener<T>({
    required String testName,
    required Future<void> Function(dynamic listener) sdkCall,
    required T Function(dynamic successResult) extractResult,
    required dynamic Function({
      required Function(dynamic) onSuccess,
      required Function(ErrorResponse?) onError,
      required Function(NativeException?) onException,
    }) createListener,
  }) async {
    T? result;
    bool completed = false;
    String? errorMessage;

    final listener = createListener(
      onSuccess: (dynamic successResult) {
        result = extractResult(successResult);
        completed = true;
      },
      onError: (ErrorResponse? apiError) {
        errorMessage = "API Error: ${apiError?.message}";
        completed = true;
      },
      onException: (NativeException? throwable) {
        errorMessage = "Exception: ${throwable?.error}";
        completed = true;
      },
    );

    await sdkCall(listener);

    expect(completed, true, reason: "$testName should complete");
    expect(errorMessage, isNull, reason: "$testName failed: $errorMessage");
    expect(result, isNotNull, reason: "$testName should return result");

    return result!;
  }

  /// Determines the correct expiry date format based on the field mask.
  /// Returns [shortDate] for MM/YY and [longDate] for MM/YYYY format.
  static String _getExpiryDateForMask(
    PaymentProduct paymentProduct, {
    String shortDate = '1228',
    String longDate = '122028',
  }) {
    final expiryDateField = paymentProduct.fields.singleWhere(
      (p) => p.id == 'expiryDate',
      orElse: () => throw Exception('No expiryDate field found'),
    );
    final mask = expiryDateField.displayHints?.mask ?? '{{99}}/{{99}}';
    final nineCount = mask.split('').where((char) => char == '9').length;
    return nineCount == 4 ? shortDate : longDate;
  }
}
