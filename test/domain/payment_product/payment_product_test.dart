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
  late final paymentProduct = createTestPaymentProduct();

  group('PaymentProduct', () {
    test('returns fields in ascending display order', () {
      expect(paymentProduct.fields, hasLength(4));
      expect(paymentProduct.fields.map((field) => field.id), ['cardNumber', 'cardholderName', 'expiryDate', 'cvv']);
    });

    test('can derive required fields', () {
      final requiredFields = paymentProduct.fields.where((field) => field.isRequired()).toList();

      expect(requiredFields, hasLength(4));
      expect(requiredFields.map((field) => field.id), ['cardNumber', 'cardholderName', 'expiryDate', 'cvv']);
    });

    test('finds fields by id', () {
      expect(paymentProduct.getField('cardNumber')?.id, 'cardNumber');
      expect(paymentProduct.getField('cvv')?.id, 'cvv');
      expect(paymentProduct.getField('cardholderName')?.id, 'cardholderName');
      expect(paymentProduct.getField('expiryDate')?.id, 'expiryDate');
      expect(paymentProduct.getField('123'), isNull);
    });

    test('applies masks on fields', () {
      final masked = paymentProduct.getField('cardNumber')?.applyMask('12345678901234567890');

      expect(masked, '1234 5678 9012 3456 789');
    });

    test('validates fields', () {
      final errors = paymentProduct.getField('cardNumber')?.validate('12345678901234567890');

      expect(errors, hasLength(2));
      expect(errors?.map((message) => message.rule?.type.name), containsAll(['length', 'luhn']));
    });

    test('reports whether a field is required', () {
      expect(paymentProduct.getField('cardNumber')?.isRequired(), isTrue);
    });
  });
}
