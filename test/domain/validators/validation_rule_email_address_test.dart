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
  group('ValidationRuleEmailAddress.validate', () {
    final rule = ValidationRuleEmailAddress(ValidationRuleType.emailAddress, 'emailAddress');
    final testCases = [
      ('test@example.com', true),
      ('user.name@example.com', true),
      ('user+name@example.com', true),
      ('user', false),
      ('@example.com', false),
      ('user@', false),
      ('user@.com', false),
    ];

    for (final (value, isValid) in testCases) {
      test('returns $isValid for "$value"', () {
        expect(rule.validate(value).valid, isValid);
      });
    }
  });

  test('type_IsEmailAddress', () {
    final rule = ValidationRuleEmailAddress(ValidationRuleType.emailAddress, 'emailAddress');

    expect(rule.type, equals(ValidationRuleType.emailAddress));
  });

  test('messageId_IsEmailAddress', () {
    final rule = ValidationRuleEmailAddress(ValidationRuleType.emailAddress, 'emailAddress');

    expect(rule.messageId, equals('emailAddress'));
  });
}
