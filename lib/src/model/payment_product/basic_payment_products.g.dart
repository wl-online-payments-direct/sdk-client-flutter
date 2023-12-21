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
