import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/native/validation/validator.dart';

void main() {
  const MethodChannel validationChannel = MethodChannel("online_payments_validation");

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(validationChannel,
        (MethodCall call) async {
      final mockResponse = [
        {"paymentProductFieldId": "cvv", "errorMessage": "CVV too short"}
      ];
      return jsonEncode(mockResponse);
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(validationChannel, null);
  });

  test("validateValueForValidationRule", () async {
    final rule = ValidationRuleLength(ValidationType.length, "cvvTooShort", 3, 4);
    final result = await ValidationRuleValidator.validateValueForValidationRule(
      "12",
      rule,
    );
    expect(result, isA<List<ValidationErrorMessage>>());
    expect(result.first.paymentProductFieldId, equals("cvv"));
    expect(result.first.errorMessage, contains("CVV"));
  });

  test("validateValidationRuleForPaymentRequestAndFieldId", () async {
    final paymentRequest = PaymentRequest(
        paymentProduct: PaymentProduct("1", "card", "cards", false, false, false, fields: []), tokenize: false);
    final rule = ValidationRuleLength(ValidationType.length, "cvvTooShort", 3, 4);
    final result = await ValidationRuleValidator.validateValidationRuleForPaymentRequestAndFieldId(
      paymentRequest,
      "cvv",
      rule,
    );
    expect(result, isA<List<ValidationErrorMessage>>());
    expect(result.first.paymentProductFieldId, equals("cvv"));
    expect(result.first.errorMessage, contains("CVV"));
  });
}
