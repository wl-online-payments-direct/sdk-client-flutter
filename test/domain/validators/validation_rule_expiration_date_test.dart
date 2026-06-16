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

String _twoDigits(int value) => value.toString().padLeft(2, '0');

void main() {
  group('ValidationRuleExpirationDate.validate', () {
    final now = DateTime.now();
    final currentMonth = _twoDigits(now.month);
    final currentYearShort = _twoDigits(now.year % 100);
    final currentYearLong = now.year.toString();
    final rule = ValidationRuleExpirationDate(ValidationRuleType.expirationDate, 'expirationDate');
    final testCases = [
      ('', false),
      ('$currentMonth$currentYearShort', true),
      ('$currentMonth$currentYearLong', true),
      ('0122', false),
      ('12345', false),
    ];

    for (final (value, isValid) in testCases) {
      test('returns $isValid for "$value"', () {
        expect(rule.validate(value).valid, isValid);
      });
    }
  });

  group('ValidationRuleExpirationDate.validate', () {
    final rule = ValidationRuleExpirationDate(ValidationRuleType.expirationDate, 'expirationDate');

    test('validate_WithNextMonth_ReturnsValid', () {
      final nextMonth = DateTime.now().add(const Duration(days: 31));
      final value = '${_twoDigits(nextMonth.month)}${_twoDigits(nextMonth.year % 100)}';

      expect(rule.validate(value).valid, isTrue);
    });

    test('validate_WithDateOneYearInFuture_ReturnsValid', () {
      final future = DateTime.now().add(const Duration(days: 365));
      final value = '${_twoDigits(future.month)}${_twoDigits(future.year % 100)}';

      expect(rule.validate(value).valid, isTrue);
    });

    test('validate_WithDateAtExactly25Years_ReturnsValid', () {
      final now = DateTime.now();
      final value = '${_twoDigits(now.month)}${_twoDigits((now.year + 25) % 100)}';

      expect(rule.validate(value).valid, isTrue);
    });

    test('validate_WithPreviousMonth_ReturnsFailed', () {
      final now = DateTime.now();
      final lastMonth = DateTime(now.year, now.month - 1);
      final value = '${_twoDigits(lastMonth.month)}${_twoDigits(lastMonth.year % 100)}';

      expect(rule.validate(value).valid, isFalse);
    });

    test('validate_WithDateBeyond25Years_ReturnsFailed', () {
      final now = DateTime.now();
      final value = '01${now.year + 26}';

      expect(rule.validate(value).valid, isFalse);
    });

    test('validate_WithMMYYFormat_ReturnsValid', () {
      final now = DateTime.now();
      final value = '${_twoDigits(now.month)}${_twoDigits(now.year % 100)}';

      expect(rule.validate(value).valid, isTrue);
    });

    test('validate_WithInvalidMonthGreaterThan12_ReturnsFailed', () {
      expect(rule.validate('1326').valid, isFalse);
    });

    test('validate_WithNonNumericCharacters_ReturnsFailed', () {
      expect(rule.validate('AB26').valid, isFalse);
    });
  });

  test('type_IsExpirationDate', () {
    final rule = ValidationRuleExpirationDate(ValidationRuleType.expirationDate, 'expirationDate');

    expect(rule.type, equals(ValidationRuleType.expirationDate));
  });

  test('messageId_IsExpirationDate', () {
    final rule = ValidationRuleExpirationDate(ValidationRuleType.expirationDate, 'expirationDate');

    expect(rule.messageId, equals('expirationDate'));
  });
}
