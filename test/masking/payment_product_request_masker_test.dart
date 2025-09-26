import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/native/masking/masking_util.dart';

void main() {
  const MethodChannel maskingChannel = MethodChannel('online_payments_masking');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(maskingChannel,
        (MethodCall call) async {
      final req = call.arguments['request'];
      return "${call.method.toUpperCase()}($req)";
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(maskingChannel, null);
  });

  final paymentRequest = PaymentRequest(
    paymentProduct: PaymentProduct("1", "card", "cards", false, false, false, fields: []),
    tokenize: false,
  );

  test("maskedValue - returns masked field value", () async {
    final result = await PaymentProductRequestMasker.maskedValue(paymentRequest, "cardNumber");

    expect(result, contains("MASKEDVALUEFORPAYMENTREQUEST"));
    expect(result, contains("cardNumber"));
  });

  test("unmaskedValue - returns unmasked field value", () async {
    final result = await PaymentProductRequestMasker.unmaskedValue(paymentRequest, "cardNumber");

    expect(result, contains("UNMASKEDVALUEFORPAYMENTREQUEST"));
  });

  test("unmaskedValue returns all unmasked values", () async {
    final result = await PaymentProductRequestMasker.unmaskedValues(paymentRequest);

    expect(result, contains("ALLUNMASKEDVALUESFORPAYMENTREQUEST"));
  });
}
