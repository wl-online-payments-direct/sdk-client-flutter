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
  group('ValidationRuleRange.validate', () {
    final rule = ValidationRuleRange(ValidationRuleType.range, 'range', 1, 100);

    for (final value in ['1', '50', '100']) {
      test('accepts $value', () {
        expect(rule.validate(value).valid, isTrue);
      });
    }

    for (final value in ['0', '101', '-5', 'abc']) {
      test('rejects $value', () {
        expect(rule.validate(value).valid, isFalse);
      });
    }
  });

  group('ValidationRuleRange.validate', () {
    final rule = ValidationRuleRange(ValidationRuleType.range, 'range', 1, 100);

    test('validate_WithExactMinBoundary_ReturnsValid', () {
      expect(rule.validate('1').valid, isTrue);
    });

    test('validate_WithExactMaxBoundary_ReturnsValid', () {
      expect(rule.validate('100').valid, isTrue);
    });

    test('validate_WithValueOneBelowMin_ReturnsFailed', () {
      expect(rule.validate('0').valid, isFalse);
    });

    test('validate_WithValueOneAboveMax_ReturnsFailed', () {
      expect(rule.validate('101').valid, isFalse);
    });
  });

  test('type_IsRange', () {
    final rule = ValidationRuleRange(ValidationRuleType.range, 'range', 1, 100);

    expect(rule.type, equals(ValidationRuleType.range));
  });

  test('messageId_IsRange', () {
    final rule = ValidationRuleRange(ValidationRuleType.range, 'range', 1, 100);

    expect(rule.messageId, equals('range'));
  });
}
