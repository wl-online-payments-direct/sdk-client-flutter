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

import '../../helpers/test_utils.dart';

void main() {
  group('BasicPaymentProduct', () {
    final basicPaymentProduct = createTestBasicPaymentProduct();

    test('exposes label and logo', () {
      expect(basicPaymentProduct.label, 'Test label');
      expect(basicPaymentProduct.logo, 'test-logo');
    });

    test('exposes specific 302 and 320 data', () {
      expect(basicPaymentProduct.paymentProduct302SpecificData?.networks, [
        'test network 1',
        'test network 2',
        'test network 3',
      ]);
      expect(basicPaymentProduct.paymentProduct320SpecificData?.networks, [
        'test network 1',
        'test network 2',
        'test network 3',
      ]);
      expect(basicPaymentProduct.paymentProduct320SpecificData?.gateway, 'test gateway');
    });

    test('exposes accounts on file', () {
      expect(basicPaymentProduct.accountsOnFile, hasLength(1));
      expect(basicPaymentProduct.accountsOnFile.first.id, '1234');
      expect(basicPaymentProduct.accountsOnFile.first.paymentProductId, 1);
    });

    test('finds an account on file by id', () {
      final accountOnFile = basicPaymentProduct.getAccountOnFile('1234');

      expect(accountOnFile, isNotNull);
      expect(accountOnFile?.id, '1234');
      expect(accountOnFile?.paymentProductId, 1);
    });

    test('returns null when account on file does not exist', () {
      expect(basicPaymentProduct.getAccountOnFile('0'), isNull);
    });
  });
}
