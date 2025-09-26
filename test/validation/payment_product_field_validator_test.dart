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
        {"paymentProductFieldId": "cardNumber", "errorMessage": "Field value is invalid"}
      ];
      return jsonEncode(mockResponse);
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(validationChannel, null);
  });

  test("validateValueForPaymentProductField", () async {
    final field = PaymentProductField("cardNumber", PaymentProductFieldType.string);
    final product = PaymentProduct("1", "card", "cards", false, false, false, fields: []);
    final result = await PaymentProductFieldValidator.validateValueForPaymentProductField(
      "4111",
      field,
      product,
    );

    expect(result, isA<List<ValidationErrorMessage>>());
    expect(result.first.paymentProductFieldId, equals("cardNumber"));
    expect(result.first.errorMessage, contains("invalid"));
  });
}
