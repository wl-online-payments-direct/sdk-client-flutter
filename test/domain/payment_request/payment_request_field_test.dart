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
  late PaymentRequestField paymentRequestField;

  setUp(() {
    paymentRequestField = PaymentRequestField(createTestCardNumberField());
  });

  group('PaymentRequestField', () {
    test('sets and gets an unmasked value', () {
      paymentRequestField.setValue('1234 5678 9012 3456 789');

      expect(paymentRequestField.getValue(), '1234567890123456789');
    });

    test('returns null when no value is set', () {
      expect(paymentRequestField.getValue(), isNull);
    });

    test('clears the value', () {
      paymentRequestField.setValue('1234 5678 9012 3456 789');
      paymentRequestField.clearValue();

      expect(paymentRequestField.getValue(), isNull);
    });

    test('returns type, required flag and id', () {
      expect(paymentRequestField.getType(), PaymentProductFieldType.numericString);
      expect(paymentRequestField.isRequired(), isTrue);
      expect(paymentRequestField.getId(), 'cardNumber');
    });

    test('returns the masked value', () {
      paymentRequestField.setValue('1234567890123456789');

      expect(paymentRequestField.getMaskedValue(), '1234 5678 9012 3456 789');
      expect(paymentRequestField.getValue(), '1234567890123456789');
    });

    test('returns a validation error when a required value is missing', () {
      final validationResult = paymentRequestField.validate();

      expect(validationResult.isValid, isFalse);
      expect(validationResult.errorMessages, hasLength(1));
    });

    test('returns a valid result for a valid card number', () {
      paymentRequestField.setValue('4242424242424242');
      final validationResult = paymentRequestField.validate();

      expect(validationResult.isValid, isTrue);
      expect(validationResult.errorMessages, isEmpty);
    });

    test('throws when writing to a read-only field', () {
      final readOnlyField = PaymentRequestField(createTestCardNumberField(), readOnly: true);

      expect(
        () => readOnlyField.setValue('4222422242224222'),
        throwsA(
          isA<InvalidArgumentError>().having(
            (error) => error.message,
            'message',
            'Cannot write read-only field: cardNumber',
          ),
        ),
      );
    });
  });
}
