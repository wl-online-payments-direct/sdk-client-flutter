// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_rule_regular_expression.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationRuleRegularExpression _$ValidationRuleRegularExpressionFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['type', 'messageId', 'pattern'],
  );
  return ValidationRuleRegularExpression(
    $enumDecode(_$ValidationTypeEnumMap, json['type']),
    json['messageId'] as String,
    json['pattern'] as String,
  );
}

Map<String, dynamic> _$ValidationRuleRegularExpressionToJson(
        ValidationRuleRegularExpression instance) =>
    <String, dynamic>{
      'type': _$ValidationTypeEnumMap[instance.type]!,
      'messageId': instance.messageId,
      'pattern': instance.pattern,
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
