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

part 'tooltip.g.dart';

/// Represents a Tooltip object.
/// Tooltips are [PaymentProduct] specific and are used to show extra information about an input field.
@JsonSerializable(explicitToJson: true)
class Tooltip {
  @JsonKey()
  final String label;

  @Deprecated(
    "In a future release, this field will be removed since it is not returned from the API.",
  )
  @JsonKey(name: "image")
  final String? imageUrl;

  @Deprecated(
    "In a future release, imageUrl will be removed from this constructor. This object should not be initialized, it is initialized automatically when returned from the API.",
  )
  Tooltip(
    this.label,
    @Deprecated("In a future release, this field will be removed.")
    this.imageUrl,
  );

  factory Tooltip.fromJson(Map<String, dynamic> json) =>
      _$TooltipFromJson(json);

  Map<String, dynamic> toJson() => _$TooltipToJson(this);
}
