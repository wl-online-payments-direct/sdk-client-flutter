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
      'httpStatusCode': instance.httpStatusCode,
      'id': instance.id,
      'message': instance.message,
      'propertyName': instance.propertyName,
      'retriable': instance.retriable,
    };
