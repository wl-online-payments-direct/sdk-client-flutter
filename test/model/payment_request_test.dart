import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

void main() {
  const validationChannel = MethodChannel("online_payments_validation");
  const maskingChannel = MethodChannel("online_payments_masking");

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(validationChannel,
        (call) async {
      return jsonEncode([
        {"paymentProductFieldId": "cardNumber", "errorMessage": "Invalid"}
      ]);
    });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(maskingChannel,
        (call) async {
      switch (call.method) {
        case "maskedValueForPaymentRequest":
          return "4111 1111 1111 1111";
        case "unmaskedValueForPaymentRequest":
          return "4111111111111111";
        case "allMaskedValuesForPaymentRequest":
          return jsonEncode({"cardNumber": "4111 1111 1111 1111"});
        case "allUnmaskedValuesForPaymentRequest":
          return jsonEncode({"cardNumber": "4111111111111111"});
      }

      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(validationChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(maskingChannel, null);
  });

  PaymentProduct testPaymentProduct() {
    return PaymentProduct("1", "card", "cards", false, false, false,
        fields: [PaymentProductField("cardNumber", PaymentProductFieldType.string)]);
  }

  test("set/get/remove value", () {
    final request = PaymentRequest(paymentProduct: testPaymentProduct(), tokenize: false);

    request.setValue("cardNumber", "4111111111111111");
    expect(request.getValue("cardNumber"), "4111111111111111");

    request.removeValue("cardNumber");
    expect(request.getValue("cardNumber"), isNull);
  });

  test("validate return validation errors", () async {
    final request = PaymentRequest(paymentProduct: testPaymentProduct());
    request.setValue("cardNumber", "4111abcd");

    final result = await request.validate();

    expect(result, isNotEmpty);
    expect(result.first.paymentProductFieldId, "cardNumber");
    expect(result.first.errorMessage, contains("Invalid"));
  });

  test("getMaskedValue", () async {
    final request = PaymentRequest(paymentProduct: testPaymentProduct());
    request.setValue("cardNumber", "4111111111111111");

    final masked = await request.getMaskedValue("cardNumber");
    expect(masked.contains(" "), true);
  });

  test("getUnmaskedValue", () async {
    final request = PaymentRequest(paymentProduct: testPaymentProduct());
    request.setValue("cardNumber", "4111 1111 1111 1111");

    final masked = await request.getUnmaskedValue("cardNumber");
    expect(masked.contains(" "), false);
  });

  test("getMaskedValues", () async {
    final request = PaymentRequest(paymentProduct: testPaymentProduct());
    final result = await request.getMaskedValues();

    expect(result["cardNumber"], "4111 1111 1111 1111");
  });

  test("getUnmaskedValues", () async {
    final request = PaymentRequest(paymentProduct: testPaymentProduct());
    final result = await request.getUnmaskedValues();

    expect(result["cardNumber"], "4111111111111111");
  });
}
