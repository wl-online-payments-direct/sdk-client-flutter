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

part of 'payment_product_field_mask_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProductFieldMaskRequest _$PaymentProductFieldMaskRequestFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['field', 'value'],
  );
  return PaymentProductFieldMaskRequest(
    PaymentProductField.fromJson(json['field'] as Map<String, dynamic>),
    json['value'] as String,
  );
}

Map<String, dynamic> _$PaymentProductFieldMaskRequestToJson(
        PaymentProductFieldMaskRequest instance) =>
    <String, dynamic>{
      'field': instance.field.toJson(),
      'value': instance.value,
    };
