// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_rule_length.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationRuleLength _$ValidationRuleLengthFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['type', 'messageId', 'minLength', 'maxLength'],
  );
  return ValidationRuleLength(
    $enumDecode(_$ValidationTypeEnumMap, json['type']),
    json['messageId'] as String,
    (json['minLength'] as num).toInt(),
    (json['maxLength'] as num).toInt(),
  );
}

Map<String, dynamic> _$ValidationRuleLengthToJson(
        ValidationRuleLength instance) =>
    <String, dynamic>{
      'type': _$ValidationTypeEnumMap[instance.type]!,
      'messageId': instance.messageId,
      'minLength': instance.minLength,
      'maxLength': instance.maxLength,
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
