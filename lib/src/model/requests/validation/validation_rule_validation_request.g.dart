// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_rule_validation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationRuleValidationRequest _$ValidationRuleValidationRequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, requiredKeys: const ['value', 'rule']);
  return ValidationRuleValidationRequest(
    json['value'] as String,
    ValidationRule.fromJson(json['rule'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ValidationRuleValidationRequestToJson(
  ValidationRuleValidationRequest instance,
) => <String, dynamic>{'value': instance.value, 'rule': instance.rule.toJson()};
