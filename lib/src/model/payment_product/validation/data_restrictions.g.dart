// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_restrictions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataRestrictions _$DataRestrictionsFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['isRequired'],
  );
  return DataRestrictions(
    isRequired: json['isRequired'] as bool,
    validators: json['validators'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$DataRestrictionsToJson(DataRestrictions instance) =>
    <String, dynamic>{
      'isRequired': instance.isRequired,
      'validators': instance.validators,
    };
