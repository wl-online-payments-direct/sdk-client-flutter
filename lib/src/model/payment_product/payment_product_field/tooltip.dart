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

@JsonSerializable(explicitToJson: true)
class Tooltip {
  @JsonKey()
  final String label;

  @JsonKey(name: "image")
  final String? imageUrl;

  Tooltip(this.label, this.imageUrl);

  factory Tooltip.fromJson(Map<String, dynamic> json) => _$TooltipFromJson(json);

  Map<String, dynamic> toJson() => _$TooltipToJson(this);
}