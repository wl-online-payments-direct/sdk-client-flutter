// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_payment_products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasicPaymentProducts _$BasicPaymentProductsFromJson(
        Map<String, dynamic> json) =>
    BasicPaymentProducts(
      (json['paymentProducts'] as List<dynamic>)
          .map((e) => BasicPaymentProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BasicPaymentProductsToJson(
        BasicPaymentProducts instance) =>
    <String, dynamic>{
      'paymentProducts': instance.products.map((e) => e.toJson()).toList(),
    };
