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

part of 'sdk_prepare_payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SdkPreparePaymentRequest _$SdkPreparePaymentRequestFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['paymentRequest'],
  );
  return SdkPreparePaymentRequest(
    PaymentRequest.fromJson(json['paymentRequest'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SdkPreparePaymentRequestToJson(
        SdkPreparePaymentRequest instance) =>
    <String, dynamic>{
      'paymentRequest': instance.paymentRequest.toJson(),
    };
