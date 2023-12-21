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
