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

import '../../helpers/test_utils.dart';

void main() {
  late AccountOnFile accountOnFile;

  setUp(() {
    accountOnFile = createTestAccountOnFile(paymentProductId: 1);
  });

  group('AccountOnFile', () {
    test('formats its label from the alias', () {
      expect(accountOnFile.label, '4111 11XX XXXX 1111');
    });

    test('exposes id and paymentProductId', () {
      expect(accountOnFile.id, '1234');
      expect(accountOnFile.paymentProductId, 1);
    });

    test('returns required attributes', () {
      final requiredAttributes = accountOnFile.getRequiredAttributes();

      expect(requiredAttributes, hasLength(1));
      expect(requiredAttributes.single.key, 'cvv');
      expect(requiredAttributes.single.status, AccountOnFileAttributeStatus.mustWrite);
      expect(requiredAttributes.single.value, '');
    });

    test('returns writable attributes', () {
      final writableAttributes = accountOnFile.getWritableAttributes();

      expect(writableAttributes, hasLength(1));
      expect(writableAttributes.single.key, 'cvv');
    });

    test('returns read-only attributes', () {
      final readOnlyAttributes = accountOnFile.getReadOnlyAttributes();

      expect(readOnlyAttributes, hasLength(2));
      expect(readOnlyAttributes.map((attribute) => attribute.key), containsAll(['alias', 'cardNumber']));
    });

    test('checks whether an attribute is writable', () {
      expect(accountOnFile.isWritable('cardNumber'), isFalse);
      expect(accountOnFile.isWritable('cvv'), isTrue);
    });

    test('returns values for known fields', () {
      expect(accountOnFile.getValue('cardNumber'), '9999-9999-9999-9999');
      expect(accountOnFile.getValue('cvv'), '');
    });

    test('getValue_WhenAttributeHasEmptyValue_ReturnsEmptyString', () {
      expect(accountOnFile.getValue('cvv'), equals(''));
    });

    test('returns null for missing fields', () {
      expect(accountOnFile.getValue('missing'), isNull);
      expect(accountOnFile.getAttribute('missing'), isNull);
    });
  });
}
