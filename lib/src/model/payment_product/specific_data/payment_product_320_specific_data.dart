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

part 'payment_product_320_specific_data.g.dart';

/// Contains payment product 320 (GooglePay) specific properties.
@JsonSerializable(explicitToJson: true)
class PaymentProduct320SpecificData {
  @JsonKey()
  final List<String> networks;
  @JsonKey()
  final String gateway;

  PaymentProduct320SpecificData(this.networks, this.gateway);

  factory PaymentProduct320SpecificData.fromJson(Map<String, dynamic> json) =>
      _$PaymentProduct320SpecificDataFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentProduct320SpecificDataToJson(this);
}
