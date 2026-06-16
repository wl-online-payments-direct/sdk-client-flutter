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
import 'rate_details.dart';

/// Represents a DccProposal object.
class DccProposal {
  final AmountOfMoney baseAmount;

  final AmountOfMoney targetAmount;

  final RateDetails rate;

  final String? disclaimerReceipt;

  final String? disclaimerDisplay;

  DccProposal(
    this.baseAmount,
    this.targetAmount,
    this.rate, {
    this.disclaimerReceipt,
    this.disclaimerDisplay,
  });

  factory DccProposal.fromJson(Map<String, dynamic> json) => DccProposal(
        AmountOfMoney.fromJson(json['baseAmount'] as Map<String, dynamic>),
        AmountOfMoney.fromJson(json['targetAmount'] as Map<String, dynamic>),
        RateDetails.fromJson(json['rate'] as Map<String, dynamic>),
        disclaimerReceipt: json['disclaimerReceipt'] as String?,
        disclaimerDisplay: json['disclaimerDisplay'] as String?,
      );
}
