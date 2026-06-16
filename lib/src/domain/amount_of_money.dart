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

/// Contains money information for a payment.
class AmountOfMoney {
  /// The amount in the smallest possible denominator of the provided currency.
  final int amount;

  /// Currency code of the transaction that will take place, should match the <a href="https://www.iso.org/iso-4217-currency-codes.html">ISO-4217 standard</a>.
  final String currencyCode;

  AmountOfMoney(this.amount, this.currencyCode);

  factory AmountOfMoney.fromJson(Map<String, dynamic> json) => AmountOfMoney(
        (json['amount'] as num).toInt(),
        json['currencyCode'] as String,
      );
}
