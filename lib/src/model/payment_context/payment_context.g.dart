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

part of 'payment_context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentContext _$PaymentContextFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'amountOfMoney',
      'countryCode',
      'isRecurring',
      'forceBasicFlow'
    ],
  );
  return PaymentContext(
    AmountOfMoney.fromJson(json['amountOfMoney'] as Map<String, dynamic>),
    json['countryCode'] as String,
    json['isRecurring'] as bool,
    forceBasicFlow: json['forceBasicFlow'] as bool? ?? false,
  );
}

Map<String, dynamic> _$PaymentContextToJson(PaymentContext instance) =>
    <String, dynamic>{
      'amountOfMoney': instance.amountOfMoney.toJson(),
      'countryCode': instance.countryCode,
      'isRecurring': instance.isRecurring,
      'forceBasicFlow': instance.forceBasicFlow,
    };
