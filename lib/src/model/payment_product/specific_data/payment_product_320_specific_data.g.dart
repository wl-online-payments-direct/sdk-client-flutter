// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_product_320_specific_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProduct320SpecificData _$PaymentProduct320SpecificDataFromJson(
  Map<String, dynamic> json,
) => PaymentProduct320SpecificData(
  (json['networks'] as List<dynamic>).map((e) => e as String).toList(),
  json['gateway'] as String,
);

Map<String, dynamic> _$PaymentProduct320SpecificDataToJson(
  PaymentProduct320SpecificData instance,
) => <String, dynamic>{
  'networks': instance.networks,
  'gateway': instance.gateway,
};
