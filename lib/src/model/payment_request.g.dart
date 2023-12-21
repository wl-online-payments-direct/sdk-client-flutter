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

part of 'payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['paymentProduct', 'tokenize'],
  );
  return PaymentRequest(
    paymentProduct:
        PaymentProduct.fromJson(json['paymentProduct'] as Map<String, dynamic>),
    tokenize: json['tokenize'] as bool? ?? false,
    accountOnFile: json['accountOnFile'] == null
        ? null
        : AccountOnFile.fromJson(json['accountOnFile'] as Map<String, dynamic>),
  )
    ..fieldValues = Map<String, String>.from(json['fieldValues'] as Map)
    ..errorMessageIds = (json['errorMessageIds'] as List<dynamic>)
        .map((e) => ValidationErrorMessage.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$PaymentRequestToJson(PaymentRequest instance) =>
    <String, dynamic>{
      'paymentProduct': instance.paymentProduct.toJson(),
      'accountOnFile': instance.accountOnFile?.toJson(),
      'fieldValues': instance.fieldValues,
      'errorMessageIds':
          instance.errorMessageIds.map((e) => e.toJson()).toList(),
      'tokenize': instance.tokenize,
    };
