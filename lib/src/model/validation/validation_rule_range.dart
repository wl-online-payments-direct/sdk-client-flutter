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

part 'validation_rule_range.g.dart';

/// Used for validation of the range of an input.
@JsonSerializable()
class ValidationRuleRange extends ValidationRule {
  @JsonKey(required: true)
  final int minValue;
  @JsonKey(required: true)
  final int maxValue;

  ValidationRuleRange(
    super.type,
    super.messageId,
    this.minValue,
    this.maxValue,
  );

  factory ValidationRuleRange.fromJson(Map<String, dynamic> json) => _$ValidationRuleRangeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ValidationRuleRangeToJson(this);
}
