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
  group('ValidationRuleRegularExpression.validate', () {
    final rule = ValidationRuleRegularExpression(
      ValidationRuleType.regularExpression,
      'regularExpression',
      r'\d{2}[a-z]{2}[A-Z]{3}',
    );
    final testCases = [('', false), ('12abABC', true), ('12abAB', false)];

    for (final (value, isValid) in testCases) {
      test('returns $isValid for "$value"', () {
        expect(rule.validate(value).valid, isValid);
      });
    }
  });

  test('type_IsRegularExpression', () {
    final rule = ValidationRuleRegularExpression(
      ValidationRuleType.regularExpression,
      'regularExpression',
      r'\d+',
    );

    expect(rule.type, equals(ValidationRuleType.regularExpression));
  });

  test('messageId_IsRegularExpression', () {
    final rule = ValidationRuleRegularExpression(
      ValidationRuleType.regularExpression,
      'regularExpression',
      r'\d+',
    );

    expect(rule.messageId, equals('regularExpression'));
  });
}
