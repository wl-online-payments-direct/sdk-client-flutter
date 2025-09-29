// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['message']);
  return ErrorResponse(
    json['message'] as String,
    apiError: json['apiError'] == null
        ? null
        : ApiError.fromJson(json['apiError'] as Map<String, dynamic>),
    throwable: json['throwable'] == null
        ? null
        : Throwable.fromJson(json['throwable'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'apiError': instance.apiError?.toJson(),
      'throwable': instance.throwable?.toJson(),
    };
