// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiError _$ApiErrorFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['errorId', 'errors'],
  );
  return ApiError(
    json['errorId'] as String,
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => ApiErrorItem.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ApiErrorToJson(ApiError instance) => <String, dynamic>{
      'errorId': instance.errorId,
      'errors': instance.errors?.map((e) => e.toJson()).toList(),
    };
