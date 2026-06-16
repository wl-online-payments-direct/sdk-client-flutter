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

import 'amount_of_money.dart';

/// Contains information about a payment, like its [AmountOfMoney] and countryCode.
class PaymentContext {
  AmountOfMoney amountOfMoney;

  /// Country code of the Country where the transaction will take place, should match the <a href="https://www.iso.org/iso-3166-country-codes.html">ISO-3166-alpha-2 standard</a>.
  String countryCode;

  bool isRecurring;

  PaymentContext(
    this.amountOfMoney,
    this.countryCode, {
    this.isRecurring = false,
  });

  PaymentContext copyWith({
    AmountOfMoney? amountOfMoney,
    String? countryCode,
    bool? isRecurring,
  }) {
    return PaymentContext(
      amountOfMoney ?? this.amountOfMoney,
      countryCode ?? this.countryCode,
      isRecurring: isRecurring ?? this.isRecurring,
    );
  }
}
