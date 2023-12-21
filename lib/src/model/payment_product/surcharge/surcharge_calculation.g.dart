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

part of 'surcharge_calculation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurchargeCalculation _$SurchargeCalculationFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['surcharges'],
  );
  return SurchargeCalculation(
    (json['surcharges'] as List<dynamic>)
        .map((e) => Surcharge.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SurchargeCalculationToJson(
        SurchargeCalculation instance) =>
    <String, dynamic>{
      'surcharges': instance.surcharges.map((e) => e.toJson()).toList(),
    };
