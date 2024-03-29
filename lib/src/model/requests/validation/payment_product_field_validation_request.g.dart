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

part of 'payment_product_field_validation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProductFieldValidationRequest
    _$PaymentProductFieldValidationRequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['value', 'field'],
  );
  return PaymentProductFieldValidationRequest(
    json['value'] as String,
    PaymentProductField.fromJson(json['field'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PaymentProductFieldValidationRequestToJson(
        PaymentProductFieldValidationRequest instance) =>
    <String, dynamic>{
      'value': instance.value,
      'field': instance.field.toJson(),
    };
