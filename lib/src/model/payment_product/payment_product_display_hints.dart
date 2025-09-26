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

part 'payment_product_display_hints.g.dart';

/// Represents a PaymentProductDisplayHints object.
@JsonSerializable(explicitToJson: true)
class PaymentProductDisplayHints {
  @JsonKey()
  final int displayOrder;

  @JsonKey()
  final String label;

  @JsonKey(name: "logo")
  String logoUrl;

  PaymentProductDisplayHints(
    this.label, {
    required this.displayOrder,
    required this.logoUrl,
  });

  factory PaymentProductDisplayHints.fromJson(Map<String, dynamic> json) => _$PaymentProductDisplayHintsFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentProductDisplayHintsToJson(this);
}
