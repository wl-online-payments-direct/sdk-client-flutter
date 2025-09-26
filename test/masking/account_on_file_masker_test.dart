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

  final aof = AccountOnFile("111", "1", attributes: []);

  test("maskedValue - returns masked value for AOF", () async {
    final result = await AccountOnFileMasker.maskedValue(aof, "cardNumber");

    expect(result, contains("MASKEDVALUEFORACCOUNTONFILE"));
    expect(result, contains("cardNumber"));
  });

  test("customMaskedValue - return custom masked value", () async {
    final result = await AccountOnFileMasker.customMaskedValue(aof, "cardNumber", "**** **** **** 1111");

    expect(result, contains("CUSTOMMASKEDVALUEFORACCOUNTONFILE"));
    expect(result, contains("cardNumber"));
    expect(result, contains("1111"));
  });
}
