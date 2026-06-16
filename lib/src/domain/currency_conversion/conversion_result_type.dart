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

/// Enum containing all the possible results of a [CurrencyConversionResult].
enum ConversionResultType {
  allowed,
  invalidCard,
  invalidMerchant,
  noRate,
  notAvailable;

  static ConversionResultType fromString(String value) {
    switch (value) {
      case 'Allowed':
        return ConversionResultType.allowed;
      case 'InvalidCard':
        return ConversionResultType.invalidCard;
      case 'InvalidMerchant':
        return ConversionResultType.invalidMerchant;
      case 'NoRate':
        return ConversionResultType.noRate;
      default:
        return ConversionResultType.notAvailable;
    }
  }
}
