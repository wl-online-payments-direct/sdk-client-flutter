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
  group('ValidationRuleFixedList.validate', () {
    test('validates values that are allowed', () {
      final rule = ValidationRuleFixedList(ValidationRuleType.fixedList, 'fixedList', const [
        'visa',
        'mastercard',
        'amex',
      ]);

      for (final value in ['visa', 'mastercard', 'amex']) {
        expect(rule.validate(value).valid, isTrue);
      }
    });

    test('rejects values that are not allowed', () {
      final rule = ValidationRuleFixedList(ValidationRuleType.fixedList, 'fixedList', const [
        'visa',
        'mastercard',
        'amex',
      ]);

      for (final value in ['discover', 'jcb']) {
        expect(rule.validate(value).valid, isFalse);
      }
    });

    test('rejects everything when the allowed list is empty', () {
      final rule = ValidationRuleFixedList(ValidationRuleType.fixedList, 'fixedList', const []);

      expect(rule.validate('anything').valid, isFalse);
    });
  });

  test('type_IsFixedList', () {
    final rule = ValidationRuleFixedList(ValidationRuleType.fixedList, 'fixedList', const ['a']);

    expect(rule.type, equals(ValidationRuleType.fixedList));
  });

  test('messageId_IsFixedList', () {
    final rule = ValidationRuleFixedList(ValidationRuleType.fixedList, 'fixedList', const ['a']);

    expect(rule.messageId, equals('fixedList'));
  });
}
