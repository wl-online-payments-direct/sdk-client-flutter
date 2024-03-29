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

part 'surcharge_rate.g.dart';

/// Represents a SurchargeRate object.
@JsonSerializable(explicitToJson: true)
class SurchargeRate {
  @JsonKey(required: true)
  final String surchargeProductTypeId;

  @JsonKey(required: true)
  final String surchargeProductTypeVersion;

  @JsonKey(required: true)
  final double adValoremRate;

  @JsonKey(required: true)
  final int specificRate;

  SurchargeRate(this.surchargeProductTypeId, this.surchargeProductTypeVersion,
      this.adValoremRate, this.specificRate);

  factory SurchargeRate.fromJson(Map<String, dynamic> json) =>
      _$SurchargeRateFromJson(json);

  Map<String, dynamic> toJson() => _$SurchargeRateToJson(this);
}
