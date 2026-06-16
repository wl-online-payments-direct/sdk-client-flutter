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

import '../rule_validation_result.dart';
import 'validation_rule.dart';

/// Used for validation of the Luhn check.
class ValidationRuleLuhn extends ValidationRule {
  ValidationRuleLuhn(super.type, super.messageId);

  @override
  RuleValidationResult validate(String value) {
    final digits = value.replaceAll(RegExp(r'[\s-]'), '');

    if (!RegExp(r'^\d{2,}$').hasMatch(digits)) {
      return const RuleValidationResult(valid: false, message: 'Card number is in invalid format.');
    }

    var sum = 0;
    var isEven = false;
    for (var i = digits.length - 1; i >= 0; i--) {
      var digit = int.parse(digits[i]);
      if (isEven) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
      isEven = !isEven;
    }

    return RuleValidationResult(
      valid: sum % 10 == 0,
      message: sum % 10 == 0 ? '' : 'Card number is in invalid format.',
    );
  }
}
