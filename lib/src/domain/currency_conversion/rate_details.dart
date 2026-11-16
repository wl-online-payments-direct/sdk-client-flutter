/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2026 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */

/// Represents a RateDetails object.
class RateDetails {
  final double exchangeRate;

  final double? _invertedExchangeRate;

  final double markUpRate;

  final String quotationDateTime;

  final String source;

  RateDetails(
    this.exchangeRate,
    double invertedExchangeRate,
    this.markUpRate,
    this.quotationDateTime,
    this.source,
  ) : _invertedExchangeRate = invertedExchangeRate;

  RateDetails._fromApi(
    this.exchangeRate,
    this._invertedExchangeRate,
    this.markUpRate,
    this.quotationDateTime,
    this.source,
  );

  /// Throws a [StateError] when the API response contained no inverted exchange rate.
  double get invertedExchangeRate =>
      _invertedExchangeRate ?? (throw StateError('The rate details have no inverted exchange rate.'));

  factory RateDetails.fromJson(Map<String, dynamic> json) => RateDetails._fromApi(
        (json['exchangeRate'] as num).toDouble(),
        (json['invertedExchangeRate'] as num?)?.toDouble(),
        (json['markUpRate'] as num).toDouble(),
        json['quotationDateTime'] as String,
        json['source'] as String,
      );
}
