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
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Session Error Handling Tests', () {
    late Session session;

    setUpAll(() {
      session = Session(
        'test-session-id',
        'test-customer-id', 
        'https://test.api.url',
        'https://test.asset.url',
        appIdentifier: 'TestApp/1.0.0',
      );
    });

    test('should handle invalid session parameters', () {
      expect(() => Session('', 'test', 'test', 'test'), throwsAssertionError);
      expect(() => Session('test', '', 'test', 'test'), throwsAssertionError);
      expect(() => Session('test', 'test', '', 'test'), throwsAssertionError);
      expect(() => Session('test', 'test', 'test', ''), throwsAssertionError);
    });

    test('should handle platform exceptions in getPublicKey', () async {
      const MethodChannel channel = MethodChannel('online_payments_sdk');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'getPublicKey') {
            throw PlatformException(
              code: 'NETWORK_ERROR',
              message: 'Network connection failed',
              details: 'Could not connect to server'
            );
          }
          return null;
        });

      await session.getPublicKey(
        listener: PublicKeyResponseListener(
          onSuccess: (key) => fail('Should not succeed'),
          onError: (error) => fail('Should not call onError'),
          onException: (exception) {
            expect(exception?.error, contains('Network connection failed'));
          },
        ),
      );

      // Clean up
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    });

    test('should handle API errors in getBasicPaymentProducts', () async {
      const MethodChannel channel = MethodChannel('online_payments_sdk');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'getBasicPaymentProducts') {
            return '{"status": "apiError", "error": {"errorCode": "9002", "message": "Invalid request"}}';
          }
          return null;
        });

      await session.getBasicPaymentProducts(
        request: BasicPaymentProductsRequest(
          paymentContext: PaymentContext(
            AmountOfMoney(1000, 'EUR'),
            'NL',
            false,
          ),
        ),
        listener: BasicPaymentProductsResponseListener(
          onSuccess: (products) => fail('Should not succeed'),
          onError: (error) {
            expect(error?.message, contains('Invalid request'));
          },
          onException: (exception) => fail('Should not call onException'),
        ),
      );

      // Clean up
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    });

    test('should handle malformed JSON responses', () async {
      const MethodChannel channel = MethodChannel('online_payments_sdk');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'getPublicKey') {
            return 'invalid json response';
          }
          return null;
        });

      bool exceptionCaught = false;
      await session.getPublicKey(
        listener: PublicKeyResponseListener(
          onSuccess: (key) => fail('Should not succeed'),
          onError: (error) => fail('Should not call onError'),
          onException: (exception) {
            exceptionCaught = true;
            expect(exception, isNotNull);
          },
        ),
      );

      expect(exceptionCaught, true);

      // Clean up
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    });

    test('should create PaymentContext with valid parameters', () {
      // Test that PaymentContext can be created with valid parameters
      final context1 = PaymentContext(AmountOfMoney(100, 'EUR'), 'NL', false);
      expect(context1.amountOfMoney.amount, equals(100));
      expect(context1.amountOfMoney.currencyCode, equals('EUR'));
      expect(context1.countryCode, equals('NL'));
      expect(context1.isRecurring, equals(false));

      // Test with different valid values
      final context2 = PaymentContext(AmountOfMoney(0, 'USD'), 'US', true);
      expect(context2.amountOfMoney.amount, equals(0));
      expect(context2.isRecurring, equals(true));
    });
  });
}