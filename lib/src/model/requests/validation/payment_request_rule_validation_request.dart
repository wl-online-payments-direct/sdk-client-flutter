/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2025 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import 'package:json_annotation/json_annotation.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

part 'payment_request_rule_validation_request.g.dart';

/// Request used to validate a [PaymentProductField] in a [PaymentRequest] with a specific [ValidationRule].
@JsonSerializable(explicitToJson: true)
class PaymentRequestRuleValidationRequest {
  @JsonKey(required: true)
  final PaymentRequest paymentRequest;

  @JsonKey(required: true)
  final String fieldId;

  @JsonKey(required: true)
  final ValidationRule rule;

  PaymentRequestRuleValidationRequest(
    this.paymentRequest,
    this.fieldId,
    this.rule,
  );

  factory PaymentRequestRuleValidationRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestRuleValidationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentRequestRuleValidationRequestToJson(this);
}
