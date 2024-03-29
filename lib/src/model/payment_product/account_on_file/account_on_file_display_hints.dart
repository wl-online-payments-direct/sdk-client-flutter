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

part 'account_on_file_display_hints.g.dart';

/// Represents a AccountOnFileDisplayHints object.
@JsonSerializable(explicitToJson: true)
class AccountOnFileDisplayHints {
  @JsonKey()
  final List<LabelTemplateElement> labelTemplate;

  AccountOnFileDisplayHints(this.labelTemplate);

  factory AccountOnFileDisplayHints.fromJson(Map<String, dynamic> json) =>
      _$AccountOnFileDisplayHintsFromJson(json);

  Map<String, dynamic> toJson() => _$AccountOnFileDisplayHintsToJson(this);
}
