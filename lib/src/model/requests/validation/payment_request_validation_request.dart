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

part 'payment_request_validation_request.g.dart';

/// Request used to validate a [PaymentProductField] in a [PaymentRequest].
@JsonSerializable(explicitToJson: true)
class PaymentRequestValidationRequest {
  @JsonKey(required: true)
  final PaymentRequest paymentRequest;

  @JsonKey(required: false)
  final String? fieldId;

  PaymentRequestValidationRequest(this.paymentRequest, {this.fieldId});

  factory PaymentRequestValidationRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestValidationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentRequestValidationRequestToJson(this);
}
