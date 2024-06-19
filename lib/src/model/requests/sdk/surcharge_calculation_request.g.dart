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

part of 'surcharge_calculation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurchargeCalculationRequest _$SurchargeCalculationRequestFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['amountOfMoney'],
  );
  return SurchargeCalculationRequest(
    AmountOfMoney.fromJson(json['amountOfMoney'] as Map<String, dynamic>),
  )
    ..partialCreditCardNumber = json['partialCreditCardNumber'] as String?
    ..paymentProductId = (json['paymentProductId'] as num?)?.toInt()
    ..token = json['token'] as String?;
}

Map<String, dynamic> _$SurchargeCalculationRequestToJson(
        SurchargeCalculationRequest instance) =>
    <String, dynamic>{
      'amountOfMoney': instance.amountOfMoney.toJson(),
      'partialCreditCardNumber': instance.partialCreditCardNumber,
      'paymentProductId': instance.paymentProductId,
      'token': instance.token,
    };
