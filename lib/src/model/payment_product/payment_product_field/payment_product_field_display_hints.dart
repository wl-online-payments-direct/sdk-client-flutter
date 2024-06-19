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

  @Deprecated(
      "In a future release, this field will be removed since it is not returned from the API.")
  @JsonKey()
  final String? link;

  @JsonKey()
  final String? mask;

  @JsonKey()
  final PreferredInputType? preferredInputType;

  @JsonKey()
  final Tooltip? tooltip;

  @JsonKey()
  final FormElement? formElement;

  @Deprecated(
      "In a future release, link will be removed from this constructor. This object should not be initialized, it is initialized automatically when returned from the API.")
  PaymentProductFieldDisplayHints(
    this.alwaysShow,
    this.obfuscate,
    this.displayOrder,
    this.label,
    this.placeholderLabel,
    @Deprecated("In a future release, this field will be removed.") this.link,
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
    this.formElement, {
    @Deprecated("In a future release, this field will be removed.")
    this.link = "",
  });

  const PaymentProductFieldDisplayHints.empty({
    this.alwaysShow = false,
    this.obfuscate = false,
    this.displayOrder = 0,
    this.label = "",
    this.placeholderLabel = "",
    @Deprecated("In a future release, this field will be removed.")
    this.link = "",
    this.mask = "",
    this.preferredInputType,
    this.tooltip,
    this.formElement,
  });

  factory PaymentProductFieldDisplayHints.fromJson(Map<String, dynamic> json) =>
      _$PaymentProductFieldDisplayHintsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PaymentProductFieldDisplayHintsToJson(this);
}
