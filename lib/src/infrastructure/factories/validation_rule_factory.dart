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

import '../../domain/validation/rules/validation_rule.dart';
import '../../domain/validation/rules/validation_rule_email_address.dart';
import '../../domain/validation/rules/validation_rule_expiration_date.dart';
import '../../domain/validation/rules/validation_rule_fixed_list.dart';
import '../../domain/validation/rules/validation_rule_iban.dart';
import '../../domain/validation/rules/validation_rule_length.dart';
import '../../domain/validation/rules/validation_rule_luhn.dart';
import '../../domain/validation/rules/validation_rule_range.dart';
import '../../domain/validation/rules/validation_rule_regular_expression.dart';
import '../../domain/validation/rules/validation_rule_terms_and_conditions.dart';
import '../../domain/validation/rules/validation_rule_type.dart';
import '../api_models/validators/validators_dto.dart';

class ValidationRuleFactory {
  List<ValidationRule> createRules(ValidatorsDto? validators) {
    final rules = <ValidationRule>[];
    if (validators == null) return rules;

    if (validators.luhn != null) {
      rules.add(ValidationRuleLuhn(ValidationRuleType.luhn, 'luhn'));
    }

    if (validators.iban != null) {
      rules.add(ValidationRuleIBAN(ValidationRuleType.iban, 'iban'));
    }

    if (validators.termsAndConditions != null) {
      rules.add(ValidationRuleTermsAndConditions(ValidationRuleType.termsAndConditions, 'termsAndConditions'));
    }

    if (validators.regularExpression?.regularExpression != null) {
      rules.add(ValidationRuleRegularExpression(
        ValidationRuleType.regularExpression,
        'regularExpression',
        validators.regularExpression!.regularExpression,
      ));
    }

    if (validators.emailAddress != null) {
      rules.add(ValidationRuleEmailAddress(ValidationRuleType.emailAddress, 'emailAddress'));
    }

    if (validators.expirationDate != null) {
      rules.add(ValidationRuleExpirationDate(ValidationRuleType.expirationDate, 'expirationDate'));
    }

    if (validators.fixedList?.allowedValues != null) {
      rules.add(ValidationRuleFixedList(
        ValidationRuleType.fixedList,
        'fixedList',
        validators.fixedList!.allowedValues,
      ));
    }

    if (validators.length != null) {
      final length = validators.length!;
      if (length.minLength != null && length.maxLength != null) {
        rules.add(ValidationRuleLength(
          ValidationRuleType.length,
          'length',
          length.minLength!,
          length.maxLength!,
        ));
      }
    }

    if (validators.range != null) {
      final range = validators.range!;
      if (range.minValue != null && range.maxValue != null) {
        rules.add(ValidationRuleRange(
          ValidationRuleType.range,
          'range',
          range.minValue!,
          range.maxValue!,
        ));
      }
    }

    return rules;
  }
}
