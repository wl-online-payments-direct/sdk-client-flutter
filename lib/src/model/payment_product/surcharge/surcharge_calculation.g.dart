// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surcharge_calculation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurchargeCalculation _$SurchargeCalculationFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['surcharges']);
  return SurchargeCalculation(
    (json['surcharges'] as List<dynamic>)
        .map((e) => Surcharge.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SurchargeCalculationToJson(
  SurchargeCalculation instance,
) => <String, dynamic>{
  'surcharges': instance.surcharges.map((e) => e.toJson()).toList(),
};
