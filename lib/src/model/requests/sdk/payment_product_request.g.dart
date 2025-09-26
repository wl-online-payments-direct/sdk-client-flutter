// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_product_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProductRequest _$PaymentProductRequestFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['productId', 'paymentContext'],
  );
  return PaymentProductRequest(
    productId: json['productId'] as String,
    paymentContext:
        PaymentContext.fromJson(json['paymentContext'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PaymentProductRequestToJson(
        PaymentProductRequest instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'paymentContext': instance.paymentContext.toJson(),
    };
