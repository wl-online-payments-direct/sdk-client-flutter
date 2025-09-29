// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_payment_products_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasicPaymentProductsRequest _$BasicPaymentProductsRequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, requiredKeys: const ['paymentContext']);
  return BasicPaymentProductsRequest(
    paymentContext: PaymentContext.fromJson(
      json['paymentContext'] as Map<String, dynamic>,
    ),
  );
}

Map<String, dynamic> _$BasicPaymentProductsRequestToJson(
  BasicPaymentProductsRequest instance,
) => <String, dynamic>{'paymentContext': instance.paymentContext.toJson()};
