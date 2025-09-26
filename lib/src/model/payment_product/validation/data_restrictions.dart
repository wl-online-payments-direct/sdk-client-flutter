/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2025 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import 'package:json_annotation/json_annotation.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

part 'data_restrictions.g.dart';

/// Represents a DataRestrictions object that is used for validating user input.
@JsonSerializable(explicitToJson: true)
class DataRestrictions {
  @JsonKey(required: true)
  final bool isRequired;

  @JsonKey()
  final Map<String, dynamic> validators;

  DataRestrictions({required this.isRequired, required this.validators});

  const DataRestrictions.empty({
    this.isRequired = false,
    this.validators = const {},
  });

  factory DataRestrictions.fromJson(Map<String, dynamic> json) {
    // If API data has validationRules, convert to validators format
    if (json.containsKey('validationRules') && json['validationRules'] != null && json['validators'] == null) {
      final rules = validationRulesFromJson(json['validationRules'] as List);
      final validatorsMap = <String, dynamic>{};

      for (final rule in rules) {
        final ruleJson = rule.toJson();
        final validatorKey = rule.messageId;
        final validatorValue = <String, dynamic>{};

        // Extract rule-specific properties, excluding type and messageId
        ruleJson.forEach((key, value) {
          if (key != 'type' && key != 'messageId') {
            validatorValue[key] = value;
          }
        });

        validatorsMap[validatorKey] = validatorValue;
      }

      return DataRestrictions(
        isRequired: json['isRequired'] as bool,
        validators: validatorsMap,
      );
    }

    // Otherwise use standard deserialization for validators format
    return _$DataRestrictionsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DataRestrictionsToJson(this);
}

List<ValidationRule> validationRulesFromJson(List<dynamic> json) {
  return json.map((e) {
    String validationType = e["type"];
    switch (validationType) {
      case ValidationType.expirationDateKey:
        return ValidationRuleExpirationDate.fromJson(e);
      case ValidationType.emailAddressKey:
        return ValidationRuleEmailAddress.fromJson(e);
      case ValidationType.fixedListKey:
        return ValidationRuleFixedList.fromJson(e);
      case ValidationType.ibanKey:
        return ValidationRuleIBAN.fromJson(e);
      case ValidationType.lengthKey:
        return ValidationRuleLength.fromJson(e);
      case ValidationType.luhnKey:
        return ValidationRuleLuhn.fromJson(e);
      case ValidationType.rangeKey:
        return ValidationRuleRange.fromJson(e);
      case ValidationType.regularExpressionKey:
        return ValidationRuleRegularExpression.fromJson(e);
      case ValidationType.termsAndConditionsKey:
        return ValidationRuleTermsAndConditions.fromJson(e);
      default:
        return ValidationRule(ValidationType.type, "validationRule");
    }
  }).toList();
}
