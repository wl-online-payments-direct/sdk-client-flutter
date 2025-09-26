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

part 'payment_product_networks.g.dart';

/// Represents a PaymentProductNetworks object.
@JsonSerializable(explicitToJson: true)
class PaymentProductNetworks {
  @JsonKey(required: true)
  final List<String> networks;

  PaymentProductNetworks(this.networks);

  factory PaymentProductNetworks.fromJson(Map<String, dynamic> json) => _$PaymentProductNetworksFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentProductNetworksToJson(this);
}
