// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_on_file_masked_value_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountOnFileMaskedValueRequest _$AccountOnFileMaskedValueRequestFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['accountOnFile', 'fieldId'],
  );
  return AccountOnFileMaskedValueRequest(
    AccountOnFile.fromJson(json['accountOnFile'] as Map<String, dynamic>),
    json['fieldId'] as String,
  );
}

Map<String, dynamic> _$AccountOnFileMaskedValueRequestToJson(
        AccountOnFileMaskedValueRequest instance) =>
    <String, dynamic>{
      'accountOnFile': instance.accountOnFile.toJson(),
      'fieldId': instance.fieldId,
    };
