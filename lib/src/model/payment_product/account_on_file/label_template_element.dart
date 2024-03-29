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

part 'label_template_element.g.dart';

/// Represents a LabelTemplateElement.
@JsonSerializable(explicitToJson: true)
class LabelTemplateElement {
  @JsonKey()
  final String attributeKey;
  @JsonKey()
  final String mask;

  LabelTemplateElement({required this.attributeKey, required this.mask});

  factory LabelTemplateElement.fromJson(Map<String, dynamic> json) =>
      _$LabelTemplateElementFromJson(json);

  Map<String, dynamic> toJson() => _$LabelTemplateElementToJson(this);
}
