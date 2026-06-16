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
  late final paymentProductField = createTestCardNumberField();

  group('PaymentProductField', () {
    test('returns label and placeholder', () {
      expect(paymentProductField.getLabel(), 'Card number');
      expect(paymentProductField.getPlaceholder(), 'test placeholder');
    });

    test('reports obfuscation and required flags', () {
      expect(paymentProductField.shouldObfuscate(), isTrue);
      expect(paymentProductField.isRequired(), isTrue);
    });

    test('applies a mask', () {
      expect(paymentProductField.applyMask('12345678901234567890'), '1234 5678 9012 3456 789');
    });

    test('returns the raw value when there is no mask', () {
      final fieldWithoutMask = createTestCardNumberField(mask: null);

      expect(fieldWithoutMask.applyMask('12345678901234567890'), '12345678901234567890');
    });

    test('removes a mask', () {
      expect(paymentProductField.removeMask('1234 5678 9012 3456 789'), '1234567890123456789');
    });

    test('returns no validation errors for a valid value', () {
      expect(paymentProductField.validate('4242424242424242'), isEmpty);
    });

    test('returns validation errors for an invalid value', () {
      final errorMessages = paymentProductField.validate('424');

      expect(errorMessages, hasLength(2));
      expect(errorMessages.map((message) => message.rule?.type.name), containsAll(['length', 'luhn']));
    });

    test('getLabel_WhenNoDisplayHints_ReturnsFieldId', () {
      final field = PaymentProductField(
        'myFieldId',
        PaymentProductFieldType.string,
        displayHints: null,
      );

      expect(field.getLabel(), equals('myFieldId'));
    });

    test('getDisplayOrder_WhenNoDisplayHints_ReturnsZero', () {
      final field = PaymentProductField(
        'myFieldId',
        PaymentProductFieldType.string,
        displayHints: null,
      );

      expect(field.getDisplayOrder(), equals(0));
    });
  });
}
