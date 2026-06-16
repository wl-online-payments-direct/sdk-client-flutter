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

import '../amount_of_money.dart';
import 'surcharge_rate.dart';
import 'surcharge_result.dart';

/// Represents a Surcharge object.
class Surcharge {
  final int paymentProductId;

  final SurchargeResult result;

  final AmountOfMoney netAmount;

  final AmountOfMoney surchargeAmount;

  final AmountOfMoney totalAmount;

  final SurchargeRate? surchargeRate;

  Surcharge(
    this.paymentProductId,
    this.result,
    this.netAmount,
    this.surchargeAmount,
    this.totalAmount, {
    this.surchargeRate,
  });

  factory Surcharge.fromJson(Map<String, dynamic> json) => Surcharge(
        (json['paymentProductId'] as num).toInt(),
        SurchargeResult.fromString(json['result'] as String? ?? ''),
        AmountOfMoney.fromJson(json['netAmount'] as Map<String, dynamic>),
        AmountOfMoney.fromJson(json['surchargeAmount'] as Map<String, dynamic>),
        AmountOfMoney.fromJson(json['totalAmount'] as Map<String, dynamic>),
        surchargeRate: json['surchargeRate'] != null
            ? SurchargeRate.fromJson(json['surchargeRate'] as Map<String, dynamic>)
            : null,
      );
}
