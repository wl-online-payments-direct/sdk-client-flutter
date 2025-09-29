// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_product_networks_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProductNetworksRequest _$PaymentProductNetworksRequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, requiredKeys: const ['productId', 'paymentContext']);
  return PaymentProductNetworksRequest(
    productId: json['productId'] as String,
    paymentContext: PaymentContext.fromJson(
      json['paymentContext'] as Map<String, dynamic>,
    ),
  );
}

Map<String, dynamic> _$PaymentProductNetworksRequestToJson(
  PaymentProductNetworksRequest instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'paymentContext': instance.paymentContext.toJson(),
};
