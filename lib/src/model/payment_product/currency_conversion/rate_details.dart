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

part 'rate_details.g.dart';

/// Represents a RateDetails object.
@JsonSerializable(explicitToJson: true)
class RateDetails {
  @JsonKey(required: true)
  final double exchangeRate;

  @JsonKey(required: true)
  final double invertedExchangeRate;

  @JsonKey(required: true)
  final double markUpRate;

  @JsonKey(required: true)
  final String quotationDateTime;

  @JsonKey(required: true)
  final String source;

  RateDetails(
    this.exchangeRate,
    this.invertedExchangeRate,
    this.markUpRate,
    this.quotationDateTime,
    this.source,
  );

  factory RateDetails.fromJson(Map<String, dynamic> json) => _$RateDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$RateDetailsToJson(this);
}
