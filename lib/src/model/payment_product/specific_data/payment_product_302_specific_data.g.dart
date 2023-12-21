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

part of 'payment_product_302_specific_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProduct302SpecificData _$PaymentProduct302SpecificDataFromJson(
        Map<String, dynamic> json) =>
    PaymentProduct302SpecificData(
      (json['networks'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PaymentProduct302SpecificDataToJson(
        PaymentProduct302SpecificData instance) =>
    <String, dynamic>{
      'networks': instance.networks,
    };
