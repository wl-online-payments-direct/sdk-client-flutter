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
import 'validation_rule_type.dart';

/// Base class for all validation rules.
abstract class ValidationRule {
  final ValidationRuleType type;
  final String messageId;

  const ValidationRule(this.type, this.messageId);

  RuleValidationResult validate(String value);
}
