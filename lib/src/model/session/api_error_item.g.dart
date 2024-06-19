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
    requiredKeys: const ['errorCode'],
  );
  return ApiErrorItem(
    errorCode: json['errorCode'] as String,
    category: json['category'] as String?,
    code: json['code'] as String? ?? "This error does not contain a code",
    httpStatusCode: (json['httpStatusCode'] as num?)?.toInt(),
    id: json['id'] as String?,
    message:
        json['message'] as String? ?? "This error does not contain a message",
    propertyName: json['propertyName'] as String?,
    retriable: json['retriable'] as bool? ?? true,
  );
}

Map<String, dynamic> _$ApiErrorItemToJson(ApiErrorItem instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'category': instance.category,
      'code': instance.code,
      'httpStatusCode': instance.httpStatusCode,
      'id': instance.id,
      'message': instance.message,
      'propertyName': instance.propertyName,
      'retriable': instance.retriable,
    };
