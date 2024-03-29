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

part 'payment_product_field_mask_request.g.dart';

/// Request used to retrieve the masked value of a [PaymentProductField].
@JsonSerializable(explicitToJson: true)
class PaymentProductFieldMaskRequest {
  @JsonKey(required: true)
  final PaymentProductField field;

  @JsonKey(required: true)
  final String value;

  PaymentProductFieldMaskRequest(this.field, this.value);
  PaymentProductFieldMaskRequest.applyMask(this.field, this.value);
  PaymentProductFieldMaskRequest.removeMask(this.field, this.value);

  factory PaymentProductFieldMaskRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentProductFieldMaskRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentProductFieldMaskRequestToJson(this);
}
