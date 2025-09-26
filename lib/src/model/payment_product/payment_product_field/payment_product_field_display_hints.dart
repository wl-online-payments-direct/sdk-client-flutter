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

part 'payment_product_field_display_hints.g.dart';

/// Represents a PaymentProductFieldDisplayHints object.
@JsonSerializable(explicitToJson: true)
class PaymentProductFieldDisplayHints {
  @JsonKey()
  final bool alwaysShow;

  @JsonKey()
  final bool obfuscate;

  @JsonKey()
  final int displayOrder;

  @JsonKey()
  final String? label;

  @JsonKey()
  final String placeholderLabel;

  @JsonKey()
  final String? mask;

  @JsonKey()
  final PreferredInputType? preferredInputType;

  @JsonKey()
  final Tooltip? tooltip;

  @JsonKey()
  final FormElement? formElement;

  PaymentProductFieldDisplayHints(
    this.alwaysShow,
    this.obfuscate,
    this.displayOrder,
    this.label,
    this.placeholderLabel,
    this.mask,
    this.preferredInputType,
    this.tooltip,
    this.formElement,
  );

  PaymentProductFieldDisplayHints.init(
    this.alwaysShow,
    this.obfuscate,
    this.displayOrder,
    this.label,
    this.placeholderLabel,
    this.mask,
    this.preferredInputType,
    this.tooltip,
    this.formElement,
  );

  const PaymentProductFieldDisplayHints.empty({
    this.alwaysShow = false,
    this.obfuscate = false,
    this.displayOrder = 0,
    this.label = "",
    this.placeholderLabel = "",
    this.mask = "",
    this.preferredInputType,
    this.tooltip,
    this.formElement,
  });

  factory PaymentProductFieldDisplayHints.fromJson(Map<String, dynamic> json) =>
      _$PaymentProductFieldDisplayHintsFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentProductFieldDisplayHintsToJson(this);
}
