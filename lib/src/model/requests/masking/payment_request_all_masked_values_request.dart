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

part 'payment_request_all_masked_values_request.g.dart';

/// Request used to retrieve all the masked or unmasked values of a [PaymentRequest].
@JsonSerializable(explicitToJson: true)
class PaymentRequestAllMaskedValuesRequest {
  @JsonKey(required: true)
  final PaymentRequest request;

  PaymentRequestAllMaskedValuesRequest(this.request);
  PaymentRequestAllMaskedValuesRequest.maskedValues(this.request);
  PaymentRequestAllMaskedValuesRequest.unmaskedValues(this.request);

  factory PaymentRequestAllMaskedValuesRequest.fromJson(
          Map<String, dynamic> json) =>
      _$PaymentRequestAllMaskedValuesRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PaymentRequestAllMaskedValuesRequestToJson(this);
}
