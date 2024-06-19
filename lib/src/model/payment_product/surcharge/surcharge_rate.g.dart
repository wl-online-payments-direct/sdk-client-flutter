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

part of 'surcharge_rate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurchargeRate _$SurchargeRateFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'surchargeProductTypeId',
      'surchargeProductTypeVersion',
      'adValoremRate',
      'specificRate'
    ],
  );
  return SurchargeRate(
    json['surchargeProductTypeId'] as String,
    json['surchargeProductTypeVersion'] as String,
    (json['adValoremRate'] as num).toDouble(),
    (json['specificRate'] as num).toInt(),
  );
}

Map<String, dynamic> _$SurchargeRateToJson(SurchargeRate instance) =>
    <String, dynamic>{
      'surchargeProductTypeId': instance.surchargeProductTypeId,
      'surchargeProductTypeVersion': instance.surchargeProductTypeVersion,
      'adValoremRate': instance.adValoremRate,
      'specificRate': instance.specificRate,
    };
