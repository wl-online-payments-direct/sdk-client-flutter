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
