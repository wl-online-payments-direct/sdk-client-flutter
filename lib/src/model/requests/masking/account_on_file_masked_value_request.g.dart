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
