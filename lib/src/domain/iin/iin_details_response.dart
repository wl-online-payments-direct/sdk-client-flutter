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

import 'iin_detail.dart';
import 'iin_status.dart';

/// Represents an IinDetailsResponse object.
class IinDetailsResponse {
  final IinStatus status;

  final int? paymentProductId;

  final String? countryCode;

  final bool? isAllowedInContext;

  final List<IinDetail> coBrands;

  IinDetailsResponse(
    this.status, {
    this.paymentProductId,
    this.countryCode,
    this.isAllowedInContext,
    this.coBrands = const [],
  });
}

