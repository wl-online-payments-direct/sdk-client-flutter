// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'throwable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Throwable _$ThrowableFromJson(Map<String, dynamic> json) => Throwable(
      json['message'] as String?,
      throwable: json['throwable'] == null
          ? null
          : Throwable.fromJson(json['throwable'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ThrowableToJson(Throwable instance) => <String, dynamic>{
      'message': instance.message,
      'throwable': instance.throwable?.toJson(),
    };
