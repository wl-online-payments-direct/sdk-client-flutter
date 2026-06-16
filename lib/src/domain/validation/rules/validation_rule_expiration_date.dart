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

/// Used for validation of an expiration date (MMYY format).
class ValidationRuleExpirationDate extends ValidationRule {
  ValidationRuleExpirationDate(super.type, super.messageId);

  @override
  RuleValidationResult validate(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (!RegExp(r'^(0[1-9]|1[0-2])(\d{2}|\d{4})$').hasMatch(digits)) {
      return const RuleValidationResult(valid: false, message: 'Invalid expiration date format.');
    }

    final month = int.parse(digits.substring(0, 2));
    final yearStr = digits.substring(2);
    final year = yearStr.length == 2 ? 2000 + int.parse(yearStr) : int.parse(yearStr);

    final now = DateTime.now();
    final expirationDate = DateTime(year, month);
    final currentMonth = DateTime(now.year, now.month);
    final maxDate = DateTime(now.year + 25, 12);

    final valid = !expirationDate.isBefore(currentMonth) && !expirationDate.isAfter(maxDate);

    return RuleValidationResult(
      valid: valid,
      message: valid ? '' : 'Expiration date cannot be in the past.',
    );
  }
}
