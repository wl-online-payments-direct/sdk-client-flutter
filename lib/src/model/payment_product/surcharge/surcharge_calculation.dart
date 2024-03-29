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

part 'surcharge_calculation.g.dart';

/// Represents a SurchargeCalculation object.
@JsonSerializable(explicitToJson: true)
class SurchargeCalculation {
  @JsonKey(required: true)
  final List<Surcharge> surcharges;

  SurchargeCalculation(this.surcharges);

  factory SurchargeCalculation.fromJson(Map<String, dynamic> json) =>
      _$SurchargeCalculationFromJson(json);

  Map<String, dynamic> toJson() => _$SurchargeCalculationToJson(this);
}
