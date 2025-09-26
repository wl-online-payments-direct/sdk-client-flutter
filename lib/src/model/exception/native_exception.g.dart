// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'native_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NativeException _$NativeExceptionFromJson(Map<String, dynamic> json) =>
    NativeException(
      error: json['error'] as String? ?? "",
      throwable: json['throwable'] == null
          ? null
          : Throwable.fromJson(json['throwable'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NativeExceptionToJson(NativeException instance) =>
    <String, dynamic>{
      'error': instance.error,
      'throwable': instance.throwable?.toJson(),
    };
