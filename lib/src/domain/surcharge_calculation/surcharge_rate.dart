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

/// Represents a SurchargeRate object.
class SurchargeRate {
  final String surchargeProductTypeId;

  final String surchargeProductTypeVersion;

  final double adValoremRate;

  final int specificRate;

  SurchargeRate(
    this.surchargeProductTypeId,
    this.surchargeProductTypeVersion,
    this.adValoremRate,
    this.specificRate,
  );

  factory SurchargeRate.fromJson(Map<String, dynamic> json) => SurchargeRate(
        json['surchargeProductTypeId'] as String,
        json['surchargeProductTypeVersion'] as String,
        (json['adValoremRate'] as num).toDouble(),
        (json['specificRate'] as num).toInt(),
      );
}
