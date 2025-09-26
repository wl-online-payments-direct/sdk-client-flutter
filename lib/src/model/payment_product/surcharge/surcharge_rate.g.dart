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
