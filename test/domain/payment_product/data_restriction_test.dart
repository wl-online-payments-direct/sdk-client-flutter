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
  group('DataRestrictions', () {
    final dataRestrictions = createTestPaymentProduct().fields.first.dataRestrictions;

    test('contains the expected validation rules', () {
      expect(dataRestrictions.isRequired, isTrue);
      expect(dataRestrictions.validationRules, hasLength(3));
      expect(
        dataRestrictions.validationRules.map((rule) => rule.type),
        containsAll([ValidationRuleType.length, ValidationRuleType.luhn, ValidationRuleType.regularExpression]),
      );
    });

    test('does not contain unrelated validation rules', () {
      expect(dataRestrictions.validationRules.any((rule) => rule.type == ValidationRuleType.emailAddress), isFalse);
    });
  });
}
