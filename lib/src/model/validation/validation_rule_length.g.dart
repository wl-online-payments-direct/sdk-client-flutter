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

part of 'validation_rule_length.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationRuleLength _$ValidationRuleLengthFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'validationType',
      'messageId',
      'minLength',
      'maxLength'
    ],
  );
  return ValidationRuleLength(
    $enumDecode(_$ValidationTypeEnumMap, json['validationType']),
    json['messageId'] as String,
    (json['minLength'] as num).toInt(),
    (json['maxLength'] as num).toInt(),
  );
}

Map<String, dynamic> _$ValidationRuleLengthToJson(
        ValidationRuleLength instance) =>
    <String, dynamic>{
      'validationType': _$ValidationTypeEnumMap[instance.validationType]!,
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
