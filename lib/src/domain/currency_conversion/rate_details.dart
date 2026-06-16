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

  final double invertedExchangeRate;

  final double markUpRate;

  final String quotationDateTime;

  final String source;

  RateDetails(
    this.exchangeRate,
    this.invertedExchangeRate,
    this.markUpRate,
    this.quotationDateTime,
    this.source,
  );

  factory RateDetails.fromJson(Map<String, dynamic> json) => RateDetails(
        (json['exchangeRate'] as num).toDouble(),
        (json['invertedExchangeRate'] as num).toDouble(),
        (json['markUpRate'] as num).toDouble(),
        json['quotationDateTime'] as String,
        json['source'] as String,
      );
}
