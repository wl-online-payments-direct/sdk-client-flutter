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
  final String dccSessionId;

  final CurrencyConversionResult result;

  final DccProposal? _proposal;

  CurrencyConversionResponse(this.dccSessionId, this.result, DccProposal proposal) : _proposal = proposal;

  CurrencyConversionResponse._fromApi(this.dccSessionId, this.result, this._proposal);

  /// The offer to show to the customer. The API sends it only when [result] is
  /// [ConversionResultType.allowed]; check the result first.
  ///
  /// Throws a [StateError] when the response contains no proposal.
  DccProposal get proposal =>
      _proposal ?? (throw StateError('The currency conversion response has no proposal (result: ${result.result.name}).'));

  factory CurrencyConversionResponse.fromJson(Map<String, dynamic> json) => CurrencyConversionResponse._fromApi(
        json['dccSessionId'] as String? ?? '',
        CurrencyConversionResult.fromJson(json['result'] as Map<String, dynamic>),
        json['proposal'] != null ? DccProposal.fromJson(json['proposal'] as Map<String, dynamic>) : null,
      );
}
