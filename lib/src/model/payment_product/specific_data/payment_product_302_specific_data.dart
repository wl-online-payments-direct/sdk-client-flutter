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

part 'payment_product_302_specific_data.g.dart';

/// Contains payment product 302 (ApplePay) specific properties.
@JsonSerializable(explicitToJson: true)
class PaymentProduct302SpecificData {
  @JsonKey()
  final List<String> networks;

  PaymentProduct302SpecificData(this.networks);

  factory PaymentProduct302SpecificData.fromJson(Map<String, dynamic> json) =>
      _$PaymentProduct302SpecificDataFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentProduct302SpecificDataToJson(this);
}
