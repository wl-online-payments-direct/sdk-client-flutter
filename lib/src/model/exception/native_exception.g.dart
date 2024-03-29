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
