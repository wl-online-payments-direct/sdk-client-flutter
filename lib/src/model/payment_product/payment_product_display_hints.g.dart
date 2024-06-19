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

part of 'payment_product_display_hints.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProductDisplayHints _$PaymentProductDisplayHintsFromJson(
        Map<String, dynamic> json) =>
    PaymentProductDisplayHints(
      json['label'] as String,
      displayOrder: (json['displayOrder'] as num).toInt(),
      logoUrl: json['logo'] as String,
    );

Map<String, dynamic> _$PaymentProductDisplayHintsToJson(
        PaymentProductDisplayHints instance) =>
    <String, dynamic>{
      'displayOrder': instance.displayOrder,
      'label': instance.label,
      'logo': instance.logoUrl,
    };
