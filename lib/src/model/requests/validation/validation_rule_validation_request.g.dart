/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2023 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_rule_validation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationRuleValidationRequest _$ValidationRuleValidationRequestFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['value', 'rule'],
  );
  return ValidationRuleValidationRequest(
    json['value'] as String,
    ValidationRule.fromJson(json['rule'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ValidationRuleValidationRequestToJson(
        ValidationRuleValidationRequest instance) =>
    <String, dynamic>{
      'value': instance.value,
      'rule': instance.rule.toJson(),
    };
