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
  group('ValidationRuleLength.validate', () {
    final rule = ValidationRuleLength(ValidationRuleType.length, 'length', 2, 5);
    final testCases = [('', false), ('12', true), ('12345', true), ('1', false), ('123456', false)];

    for (final (value, isValid) in testCases) {
      test('returns $isValid for "$value"', () {
        expect(rule.validate(value).valid, isValid);
      });
    }
  });

  group('ValidationRuleLength.validate', () {
    test('validate_WithExactMinBoundaryValue_ReturnsValid', () {
      final rule = ValidationRuleLength(ValidationRuleType.length, 'length', 2, 5);

      expect(rule.validate('12').valid, isTrue);
    });

    test('validate_WithExactMaxBoundaryValue_ReturnsValid', () {
      final rule = ValidationRuleLength(ValidationRuleType.length, 'length', 2, 5);

      expect(rule.validate('12345').valid, isTrue);
    });

    test('validate_WithZeroMinLength_AllowsEmptyString', () {
      final rule = ValidationRuleLength(ValidationRuleType.length, 'length', 0, 5);

      expect(rule.validate('').valid, isTrue);
    });

    test('validate_WithSameMinAndMax_EnforcesExactLength', () {
      final rule = ValidationRuleLength(ValidationRuleType.length, 'length', 3, 3);

      expect(rule.validate('abc').valid, isTrue);
      expect(rule.validate('ab').valid, isFalse);
      expect(rule.validate('abcd').valid, isFalse);
    });
  });

  test('minLength_ReturnsConfiguredValue', () {
    final rule = ValidationRuleLength(ValidationRuleType.length, 'length', 2, 5);

    expect(rule.minLength, equals(2));
  });

  test('maxLength_ReturnsConfiguredValue', () {
    final rule = ValidationRuleLength(ValidationRuleType.length, 'length', 2, 5);

    expect(rule.maxLength, equals(5));
  });

  test('type_IsLength', () {
    final rule = ValidationRuleLength(ValidationRuleType.length, 'length', 2, 5);

    expect(rule.type, equals(ValidationRuleType.length));
  });

  test('messageId_IsLength', () {
    final rule = ValidationRuleLength(ValidationRuleType.length, 'length', 2, 5);

    expect(rule.messageId, equals('length'));
  });
}
