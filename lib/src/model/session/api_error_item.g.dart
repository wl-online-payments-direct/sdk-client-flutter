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

part of 'api_error_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiErrorItem _$ApiErrorItemFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['code', 'message'],
  );
  return ApiErrorItem(
    json['code'] as String,
    json['message'] as String,
  );
}

Map<String, dynamic> _$ApiErrorItemToJson(ApiErrorItem instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
