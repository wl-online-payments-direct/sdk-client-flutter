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

import 'conversion_result_type.dart';

/// Represents a CurrencyConversionResult object.
class CurrencyConversionResult {
  final ConversionResultType result;

  final String? resultReason;

  CurrencyConversionResult(this.result, {this.resultReason});

  factory CurrencyConversionResult.fromJson(Map<String, dynamic> json) => CurrencyConversionResult(
        ConversionResultType.fromString(json['result'] as String? ?? ''),
        resultReason: json['resultReason'] as String?,
      );
}
