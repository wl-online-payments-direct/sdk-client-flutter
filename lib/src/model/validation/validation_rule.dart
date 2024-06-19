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
import 'package:json_annotation/json_annotation.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/validator.dart';

part 'validation_rule.g.dart';

/// Contains functionality to handle validation.
@JsonSerializable()
class ValidationRule implements ValidationRuleFunctions {
  @JsonKey(required: true)
  final ValidationType validationType;

  @JsonKey(required: true)
  final String messageId;

  ValidationRule(this.validationType, this.messageId);

  factory ValidationRule.fromJson(Map<String, dynamic> json) =>
      _$ValidationRuleFromJson(json);

  Map<String, dynamic> toJson() => _$ValidationRuleToJson(this);

  @override
  Future<List<ValidationErrorMessage>> validateValueForFieldOfPaymentRequest({
    required String fieldId,
    required PaymentRequest request,
  }) async {
    return await ValidationRuleValidator
        .validateValidationRuleForPaymentRequestAndFieldId(
            request, fieldId, this);
  }

  @override
  Future<List<ValidationErrorMessage>> validateValue({
    required String value,
  }) async {
    return await ValidationRuleValidator.validateValueForValidationRule(
        value, this);
  }
}

abstract class ValidationRuleFunctions {
  /// Validates the value of the [PaymentProductField] corresponding to the provided [fieldId] in the provided [request].
  validateValueForFieldOfPaymentRequest({
    required String fieldId,
    required PaymentRequest request,
  });

  /// Validates the provided [value].
  validateValue({required String value});
}
