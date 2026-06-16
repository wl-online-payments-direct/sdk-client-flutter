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

/// Used for validation of the range of an input.
class ValidationRuleRange extends ValidationRule {
  final int minValue;
  final int maxValue;

  ValidationRuleRange(
    super.type,
    super.messageId,
    this.minValue,
    this.maxValue,
  );

  @override
  RuleValidationResult validate(String value) {
    final number = int.tryParse(value);
    if (number == null) {
      return RuleValidationResult(
        valid: false,
        message: 'Provided value must be between $minValue and $maxValue.',
      );
    }

    final valid = number >= minValue && number <= maxValue;

    return RuleValidationResult(
      valid: valid,
      message: valid ? '' : 'Provided value must be between $minValue and $maxValue.',
    );
  }
}
