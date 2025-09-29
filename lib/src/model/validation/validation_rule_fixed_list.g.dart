// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_rule_fixed_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationRuleFixedList _$ValidationRuleFixedListFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, requiredKeys: const ['type', 'messageId', 'allowedValues']);
  return ValidationRuleFixedList(
    $enumDecode(_$ValidationTypeEnumMap, json['type']),
    json['messageId'] as String,
    (json['allowedValues'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$ValidationRuleFixedListToJson(
  ValidationRuleFixedList instance,
) => <String, dynamic>{
  'type': _$ValidationTypeEnumMap[instance.type]!,
  'messageId': instance.messageId,
  'allowedValues': instance.allowedValues,
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
