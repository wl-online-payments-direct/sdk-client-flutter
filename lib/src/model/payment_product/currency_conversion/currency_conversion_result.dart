/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2024 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import 'package:json_annotation/json_annotation.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

part 'currency_conversion_result.g.dart';

/// Represents a CurrencyConversionResult object.
@JsonSerializable(explicitToJson: true)
class CurrencyConversionResult {
  @JsonKey(required: true)
  final ConversionResultType result;

  final String? resultReason;

  CurrencyConversionResult(this.result,
      {this.resultReason});

  factory CurrencyConversionResult.fromJson(Map<String, dynamic> json) =>
      _$CurrencyConversionResultFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyConversionResultToJson(this);
}
