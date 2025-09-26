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

part 'surcharge.g.dart';

/// Represents a Surcharge object.
@JsonSerializable(explicitToJson: true)
class Surcharge {
  @JsonKey(required: true)
  final int paymentProductId;

  @JsonKey(required: true)
  final SurchargeResult result;

  @JsonKey(required: true)
  final AmountOfMoney netAmount;

  @JsonKey(required: true)
  final AmountOfMoney surchargeAmount;

  @JsonKey(required: true)
  final AmountOfMoney totalAmount;

  @JsonKey()
  final SurchargeRate? surchargeRate;

  Surcharge(
    this.paymentProductId,
    this.result,
    this.netAmount,
    this.surchargeAmount,
    this.totalAmount, {
    this.surchargeRate,
  });

  factory Surcharge.fromJson(Map<String, dynamic> json) => _$SurchargeFromJson(json);

  Map<String, dynamic> toJson() => _$SurchargeToJson(this);
}
