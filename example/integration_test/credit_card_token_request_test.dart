/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2026 Worldline and/or its affiliates.
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

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await TestCredentials.get();
  });

  group('sdk.encryptTokenRequest', () {
    late OnlinePaymentSdk sdk;

    setUp(() => sdk = TestHelpers.createSdk());
    tearDown(() => sdk.dispose());

    test('encryptTokenRequest_WhenProductIdNotSet_ThrowsSdkError', () async {
      final request = CreditCardTokenRequest();
      request.setCardNumber('4242424242424242');

      await expectLater(
        () => sdk.encryptTokenRequest(request),
        throwsA(isA<SdkError>()),
      );
    });

    test('encryptTokenRequest_WithInvalidData_StillProducesEncryptedOutput', () async {
      final request = CreditCardTokenRequest();
      request.setPaymentProductId(1);
      request.setCardNumber('4567350000427977');
      // no cardholderName, expiryDate, or securityCode set

      final result = await sdk.encryptTokenRequest(request);

      expect(result.encryptedCustomerInput, isNotEmpty);
    });

    test('encryptTokenRequest_GetValues_WithAllFieldsSet_ReturnsCorrectFieldsMap', () async {
      final request = CreditCardTokenRequest();
      request.setPaymentProductId(1);
      request.setCardNumber('4567350000427977');
      request.setCardholderName('Test User');
      request.setExpiryDate('1230');
      request.setSecurityCode('123');

      final values = request.getValues();

      expect(values['cardNumber'], equals('4567350000427977'));
      expect(values['cardholderName'], equals('Test User'));
      expect(values['expiryDate'], equals('1230'));
      expect(values['cvv'], equals('123'));
      expect(values['paymentProductId'], equals(1));
    });

    test('encryptTokenRequest_ReturnsEncodedClientMetaInfo', () async {
      final request = CreditCardTokenRequest();
      request.setPaymentProductId(1);
      request.setCardNumber('4567350000427977');

      final result = await sdk.encryptTokenRequest(request);

      expect(result.encodedClientMetaInfo, isNotEmpty);
    });
  });
}
