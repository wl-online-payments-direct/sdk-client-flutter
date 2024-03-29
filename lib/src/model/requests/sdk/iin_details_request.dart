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

part 'iin_details_request.g.dart';

/// Request used to retrieve an [IinDetailsResponse] from the API.
@JsonSerializable(explicitToJson: true)
class IinDetailsRequest {
  @JsonKey(required: true)
  final String partialCreditCardNumber;

  @JsonKey(required: true)
  final PaymentContext paymentContext;

  IinDetailsRequest(
      {required this.partialCreditCardNumber, required this.paymentContext});

  factory IinDetailsRequest.fromJson(Map<String, dynamic> json) =>
      _$IinDetailsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$IinDetailsRequestToJson(this);
}
