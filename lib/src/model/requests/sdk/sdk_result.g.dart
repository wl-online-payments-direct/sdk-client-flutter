// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sdk_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SdkResult<T> _$SdkResultFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => SdkResult<T>(
  _$nullableGenericFromJson(json['data'], fromJsonT),
  json['error'] == null
      ? null
      : ErrorResponse.fromJson(json['error'] as Map<String, dynamic>),
  throwable: json['throwable'] == null
      ? null
      : Throwable.fromJson(json['throwable'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SdkResultToJson<T>(
  SdkResult<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'data': _$nullableGenericToJson(instance.data, toJsonT),
  'error': instance.error?.toJson(),
  'throwable': instance.throwable?.toJson(),
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);
