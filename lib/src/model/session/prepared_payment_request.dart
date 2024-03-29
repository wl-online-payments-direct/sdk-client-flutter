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

part 'prepared_payment_request.g.dart';

/// Contains all encrypted [PaymentRequest] data required for creating a payment.
@JsonSerializable(explicitToJson: true)
class PreparedPaymentRequest {
  @JsonKey(required: true)
  final String encryptedFields;

  @JsonKey(required: true)
  final String encodedClientMetaInfo;

  PreparedPaymentRequest(this.encryptedFields, this.encodedClientMetaInfo);

  factory PreparedPaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$PreparedPaymentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PreparedPaymentRequestToJson(this);
}
