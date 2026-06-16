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
  group('ValidationRuleTermsAndConditions.validate', () {
    final rule = ValidationRuleTermsAndConditions(ValidationRuleType.termsAndConditions, 'termsAndConditions');

    test('accepts "true"', () {
      expect(rule.validate('true').valid, isTrue);
    });

    for (final value in ['false', 'yes', '1', '']) {
      test('rejects $value', () {
        expect(rule.validate(value).valid, isFalse);
      });
    }
  });

  test('type_IsTermsAndConditions', () {
    final rule = ValidationRuleTermsAndConditions(ValidationRuleType.termsAndConditions, 'termsAndConditions');

    expect(rule.type, equals(ValidationRuleType.termsAndConditions));
  });

  test('messageId_IsTermsAndConditions', () {
    final rule = ValidationRuleTermsAndConditions(ValidationRuleType.termsAndConditions, 'termsAndConditions');

    expect(rule.messageId, equals('termsAndConditions'));
  });
}
