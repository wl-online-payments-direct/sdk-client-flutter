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

import 'currency_conversion_result.dart';
import 'dcc_proposal.dart';

/// Represents the response from a currency conversion request.
class CurrencyConversionResponse {
  final String docSessionId;

  final CurrencyConversionResult result;

  final DccProposal proposal;

  CurrencyConversionResponse(this.docSessionId, this.result, this.proposal);

  factory CurrencyConversionResponse.fromJson(Map<String, dynamic> json) => CurrencyConversionResponse(
        json['docSessionId'] as String? ?? '',
        CurrencyConversionResult.fromJson(json['result'] as Map<String, dynamic>),
        DccProposal.fromJson(json['proposal'] as Map<String, dynamic>),
      );
}
