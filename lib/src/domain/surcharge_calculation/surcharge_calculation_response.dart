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

import 'surcharge.dart';

/// Represents the response from a surcharge calculation request.
class SurchargeCalculationResponse {
  final List<Surcharge> surcharges;

  SurchargeCalculationResponse(this.surcharges);

  factory SurchargeCalculationResponse.fromJson(Map<String, dynamic> json) => SurchargeCalculationResponse(
        (json['surcharges'] as List<dynamic>? ?? [])
            .map((e) => Surcharge.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
