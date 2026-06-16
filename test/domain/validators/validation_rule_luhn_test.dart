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
  group('ValidationRuleLuhn.validate', () {
    final rule = ValidationRuleLuhn(ValidationRuleType.luhn, 'luhn');
    final testCases = [('', false), ('79927398713', true), ('79927398712', false)];

    for (final (value, isValid) in testCases) {
      test('returns $isValid for "$value"', () {
        expect(rule.validate(value).valid, isValid);
      });
    }
  });

  group('ValidationRuleLuhn.validate', () {
    final rule = ValidationRuleLuhn(ValidationRuleType.luhn, 'luhn');

    test('validate_WithValidVisaCardNumber_ReturnsValid', () {
      expect(rule.validate('4111111111111111').valid, isTrue);
    });

    test('validate_WithValidMasterCardNumber_ReturnsValid', () {
      expect(rule.validate('5555555555554444').valid, isTrue);
    });

    test('validate_WithValidAmexCardNumber_ReturnsValid', () {
      expect(rule.validate('378282246310005').valid, isTrue);
    });

    test('validate_WithCardNumberContainingSpacesAndDashes_ReturnsValid', () {
      expect(rule.validate('4111 1111-1111 1111').valid, isTrue);
    });

    test('validate_WithMultipleInvalidCardNumbers_ReturnsFailed', () {
      expect(rule.validate('4111111111111112').valid, isFalse);
      expect(rule.validate('1234567890123456').valid, isFalse);
    });

    test('validate_WithNonNumericCharacters_ReturnsFailed', () {
      expect(rule.validate('411111111111111a').valid, isFalse);
      expect(rule.validate('4111.1111.1111.1111').valid, isFalse);
    });
  });

  test('type_IsLuhn', () {
    final rule = ValidationRuleLuhn(ValidationRuleType.luhn, 'luhn');

    expect(rule.type, equals(ValidationRuleType.luhn));
  });

  test('messageId_IsLuhn', () {
    final rule = ValidationRuleLuhn(ValidationRuleType.luhn, 'luhn');

    expect(rule.messageId, equals('luhn'));
  });
}
