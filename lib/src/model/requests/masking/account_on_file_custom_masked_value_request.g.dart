// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_on_file_custom_masked_value_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountOnFileCustomMaskedValueRequest
_$AccountOnFileCustomMaskedValueRequestFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['accountOnFile', 'fieldId', 'mask']);
  return AccountOnFileCustomMaskedValueRequest(
    AccountOnFile.fromJson(json['accountOnFile'] as Map<String, dynamic>),
    json['fieldId'] as String,
    json['mask'] as String,
  );
}

Map<String, dynamic> _$AccountOnFileCustomMaskedValueRequestToJson(
  AccountOnFileCustomMaskedValueRequest instance,
) => <String, dynamic>{
  'accountOnFile': instance.accountOnFile.toJson(),
  'fieldId': instance.fieldId,
  'mask': instance.mask,
};
