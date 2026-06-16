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
import 'package:online_payments_sdk/online_payments_sdk.dart';

void main() {
  group('CreditCardTokenRequest', () {
    late CreditCardTokenRequest tokenRequest;

    setUp(() {
      tokenRequest = CreditCardTokenRequest();
    });

    test('returns all keys with null values when nothing is set', () {
      expect(tokenRequest.getValues(), {
        'cardNumber': null,
        'cardholderName': null,
        'expiryDate': null,
        'cvv': null,
        'paymentProductId': null,
      });
    });

    test('returns all set values', () {
      tokenRequest.setCardNumber('4567350000427977');
      tokenRequest.setCardholderName('John Doe');
      tokenRequest.setExpiryDate('12/2030');
      tokenRequest.setSecurityCode('123');
      tokenRequest.setPaymentProductId(1);

      expect(tokenRequest.getValues(), {
        'cardNumber': '4567350000427977',
        'cardholderName': 'John Doe',
        'expiryDate': '12/2030',
        'cvv': '123',
        'paymentProductId': 1,
      });
    });

    test('sets and gets individual fields', () {
      tokenRequest.setCardNumber('4567350000427977');
      tokenRequest.setCardholderName('Test cardholder name');
      tokenRequest.setExpiryDate('12/2030');
      tokenRequest.setPaymentProductId(1);
      tokenRequest.setSecurityCode('123');

      expect(tokenRequest.getCardNumber(), '4567350000427977');
      expect(tokenRequest.getCardholderName(), 'Test cardholder name');
      expect(tokenRequest.getExpiryDate(), '12/2030');
      expect(tokenRequest.getPaymentProductId(), 1);
      expect(tokenRequest.getSecurityCode(), '123');
    });
  });
}
