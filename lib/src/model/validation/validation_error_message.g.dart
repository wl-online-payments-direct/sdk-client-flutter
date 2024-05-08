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

part of 'validation_error_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationErrorMessage _$ValidationErrorMessageFromJson(
        Map<String, dynamic> json) =>
    ValidationErrorMessage(
      errorMessage: json['errorMessage'] as String,
      paymentProductFieldId: json['paymentProductFieldId'] as String,
      rule: validationRuleFromJson(json['rule']),
    );

Map<String, dynamic> _$ValidationErrorMessageToJson(
        ValidationErrorMessage instance) =>
    <String, dynamic>{
      'errorMessage': instance.errorMessage,
      'paymentProductFieldId': instance.paymentProductFieldId,
      'rule': instance.rule,
    };
