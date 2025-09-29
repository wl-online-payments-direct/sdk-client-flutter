// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_on_file_attribute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountOnFileAttribute _$AccountOnFileAttributeFromJson(
  Map<String, dynamic> json,
) => AccountOnFileAttribute(
  key: json['key'] as String? ?? "",
  value: json['value'] as String? ?? "",
  status: $enumDecodeNullable(
    _$AccountOnFileAttributeStatusEnumMap,
    json['status'],
  ),
);

Map<String, dynamic> _$AccountOnFileAttributeToJson(
  AccountOnFileAttribute instance,
) => <String, dynamic>{
  'key': instance.key,
  'value': instance.value,
  'status': _$AccountOnFileAttributeStatusEnumMap[instance.status],
};

const _$AccountOnFileAttributeStatusEnumMap = {
  AccountOnFileAttributeStatus.readOnly: 'READ_ONLY',
  AccountOnFileAttributeStatus.canWrite: 'CAN_WRITE',
  AccountOnFileAttributeStatus.mustWrite: 'MUST_WRITE',
};
