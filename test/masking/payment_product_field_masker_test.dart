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
      if (call.method == 'applyMaskForPaymentProductField') {
        final request = call.arguments['request'];

        return "MASKED($request)";
      } else if (call.method == 'removeMaskForPaymentProductField') {
        final request = call.arguments['request'];

        return "UNMASKED($request)";
      }

      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(maskingChannel, null);
  });

  test("applyMask - returns masked value", () async {
    final field = PaymentProductField('cardNumber', PaymentProductFieldType.string);

    const inputValue = "4111111111111111";

    final result = await PaymentProductFieldMasker.applyMask(field, inputValue);

    expect(result, contains("MASKED"));
    expect(result, contains(inputValue));
  });

  test("removeMask - return unmasked value", () async {
    final field = PaymentProductField('cardNumber', PaymentProductFieldType.string);

    const inputValue = "4111 1111 1111 1111";

    final result = await PaymentProductFieldMasker.removeMask(field, inputValue);

    expect(result, contains("UNMASKED"));
    expect(result, contains(inputValue));
  });
}
