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
        {"paymentProductFieldId": "cardNumber", "errorMessage": "Invalid card number"}
      ];

      return jsonEncode(mockResponse);
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(validationChannel, null);
  });

  test("validatePaymentRequest", () async {
    final paymentRequest = PaymentRequest(
        paymentProduct: PaymentProduct("1", "card", "cards", false, false, false, fields: []), tokenize: false);

    final result = await PaymentRequestValidator.validatePaymentRequest(paymentRequest);

    expect(result, isA<List<ValidationErrorMessage>>());
    expect(result.length, greaterThan(0));
    expect(result.first.paymentProductFieldId, equals("cardNumber"));
  });

  test("validatePaymentProductFieldForPaymentRequest", () async {
    final paymentRequest = PaymentRequest(
        paymentProduct: PaymentProduct("1", "card", "cards", false, false, false, fields: []), tokenize: false);

    final result =
        await PaymentRequestValidator.validatePaymentProductFieldForPaymentRequest("cardNumber", paymentRequest);

    expect(result, isA<List<ValidationErrorMessage>>());
    expect(result.first.errorMessage, contains("Invalid card number"));
  });
}
