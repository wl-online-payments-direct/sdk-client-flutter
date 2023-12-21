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

part of 'account_on_file_attribute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountOnFileAttribute _$AccountOnFileAttributeFromJson(
        Map<String, dynamic> json) =>
    AccountOnFileAttribute(
      key: json['key'] as String? ?? "",
      value: json['value'] as String? ?? "",
      status: $enumDecodeNullable(
          _$AccountOnFileAttributeStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$AccountOnFileAttributeToJson(
        AccountOnFileAttribute instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'status': _$AccountOnFileAttributeStatusEnumMap[instance.status],
    };

const _$AccountOnFileAttributeStatusEnumMap = {
  AccountOnFileAttributeStatus.readOnly: 'READ_ONLY',
  AccountOnFileAttributeStatus.canWrite: 'CAN_WRITE',
  AccountOnFileAttributeStatus.mustWrite: 'MUST_WRITE',
};
