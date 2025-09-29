// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_product_networks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProductNetworks _$PaymentProductNetworksFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, requiredKeys: const ['networks']);
  return PaymentProductNetworks(
    (json['networks'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$PaymentProductNetworksToJson(
  PaymentProductNetworks instance,
) => <String, dynamic>{'networks': instance.networks};
