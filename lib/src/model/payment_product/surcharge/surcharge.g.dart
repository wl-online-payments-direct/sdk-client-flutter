// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surcharge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Surcharge _$SurchargeFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'paymentProductId',
      'result',
      'netAmount',
      'surchargeAmount',
      'totalAmount',
    ],
  );
  return Surcharge(
    (json['paymentProductId'] as num).toInt(),
    $enumDecode(_$SurchargeResultEnumMap, json['result']),
    AmountOfMoney.fromJson(json['netAmount'] as Map<String, dynamic>),
    AmountOfMoney.fromJson(json['surchargeAmount'] as Map<String, dynamic>),
    AmountOfMoney.fromJson(json['totalAmount'] as Map<String, dynamic>),
    surchargeRate: json['surchargeRate'] == null
        ? null
        : SurchargeRate.fromJson(json['surchargeRate'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SurchargeToJson(Surcharge instance) => <String, dynamic>{
  'paymentProductId': instance.paymentProductId,
  'result': _$SurchargeResultEnumMap[instance.result]!,
  'netAmount': instance.netAmount.toJson(),
  'surchargeAmount': instance.surchargeAmount.toJson(),
  'totalAmount': instance.totalAmount.toJson(),
  'surchargeRate': instance.surchargeRate?.toJson(),
};

const _$SurchargeResultEnumMap = {
  SurchargeResult.ok: 'OK',
  SurchargeResult.noSurcharge: 'NO_SURCHARGE',
};
