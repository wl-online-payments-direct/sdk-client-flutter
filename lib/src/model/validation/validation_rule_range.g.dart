// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_rule_range.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationRuleRange _$ValidationRuleRangeFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['type', 'messageId', 'minValue', 'maxValue'],
  );
  return ValidationRuleRange(
    $enumDecode(_$ValidationTypeEnumMap, json['type']),
    json['messageId'] as String,
    (json['minValue'] as num).toInt(),
    (json['maxValue'] as num).toInt(),
  );
}

Map<String, dynamic> _$ValidationRuleRangeToJson(
        ValidationRuleRange instance) =>
    <String, dynamic>{
      'type': _$ValidationTypeEnumMap[instance.type]!,
      'messageId': instance.messageId,
      'minValue': instance.minValue,
      'maxValue': instance.maxValue,
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
