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

part of 'payment_request_rule_validation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentRequestRuleValidationRequest
    _$PaymentRequestRuleValidationRequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['paymentRequest', 'fieldId', 'rule'],
  );
  return PaymentRequestRuleValidationRequest(
    PaymentRequest.fromJson(json['paymentRequest'] as Map<String, dynamic>),
    json['fieldId'] as String,
    ValidationRule.fromJson(json['rule'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PaymentRequestRuleValidationRequestToJson(
        PaymentRequestRuleValidationRequest instance) =>
    <String, dynamic>{
      'paymentRequest': instance.paymentRequest.toJson(),
      'fieldId': instance.fieldId,
      'rule': instance.rule.toJson(),
    };
