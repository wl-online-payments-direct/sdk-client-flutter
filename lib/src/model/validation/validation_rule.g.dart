// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationRule _$ValidationRuleFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['type', 'messageId'],
  );
  return ValidationRule(
    $enumDecode(_$ValidationTypeEnumMap, json['type']),
    json['messageId'] as String,
  );
}

Map<String, dynamic> _$ValidationRuleToJson(ValidationRule instance) =>
    <String, dynamic>{
      'type': _$ValidationTypeEnumMap[instance.type]!,
      'messageId': instance.messageId,
    };

const _$ValidationTypeEnumMap = {
  ValidationType.expirationDate: 'EXPIRATIONDATE',
  ValidationType.emailAddress: 'EMAILADDRESS',
  ValidationType.fixedList: 'FIXEDLIST',
  ValidationType.iban: 'IBAN',
  ValidationType.length: 'LENGTH',
  ValidationType.luhn: 'LUHN',
  ValidationType.range: 'RANGE',
  ValidationType.regularExpression: 'REGULAREXPRESSION',
  ValidationType.required: 'REQUIRED',
  ValidationType.type: 'TYPE',
  ValidationType.termsAndConditions: 'TERMSANDCONDITIONS',
};
