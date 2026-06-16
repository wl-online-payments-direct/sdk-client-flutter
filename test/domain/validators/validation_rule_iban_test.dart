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
  group('ValidationRuleIBAN.validate', () {
    final rule = ValidationRuleIBAN(ValidationRuleType.iban, 'iban');

    for (final value in [
      'DE89370400440532013000',
      'GB82WEST12345698765432',
      'NL91ABNA0417164300',
      'FR1420041010050500013M02606',
      'DE89 3704 0044 0532 0130 00',
      'GB82 WEST 1234 5698 7654 32',
    ]) {
      test('accepts $value', () {
        expect(rule.validate(value).valid, isTrue);
      });
    }

    for (final value in [
      'DE89370400440532013001',
      'DE8937040044',
      'XX89370400440532013000',
      'not-an-iban',
      '1234567890',
      '',
    ]) {
      test('rejects $value', () {
        expect(rule.validate(value).valid, isFalse);
      });
    }
  });

  test('type_IsIban', () {
    final rule = ValidationRuleIBAN(ValidationRuleType.iban, 'iban');

    expect(rule.type, equals(ValidationRuleType.iban));
  });

  test('messageId_IsIban', () {
    final rule = ValidationRuleIBAN(ValidationRuleType.iban, 'iban');

    expect(rule.messageId, equals('iban'));
  });
}
