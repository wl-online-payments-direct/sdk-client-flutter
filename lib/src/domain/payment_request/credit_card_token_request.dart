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

/// A class for handling data for creating a token.
class CreditCardTokenRequest {
  String? _cardNumber;
  String? _cardholderName;
  String? _expiryDate;
  String? _securityCode;
  int? _paymentProductId;

  void setCardNumber(String? cardNumber) => _cardNumber = cardNumber;

  void setCardholderName(String? cardholderName) => _cardholderName = cardholderName;

  void setExpiryDate(String? expiryDate) => _expiryDate = expiryDate;

  void setSecurityCode(String? securityCode) => _securityCode = securityCode;

  void setPaymentProductId(int? paymentProductId) => _paymentProductId = paymentProductId;

  String? getCardNumber() => _cardNumber;

  String? getCardholderName() => _cardholderName;

  String? getExpiryDate() => _expiryDate;

  String? getSecurityCode() => _securityCode;

  int? getPaymentProductId() => _paymentProductId;

  /// Returns all values as a map.
  Map<String, Object?> getValues() {
    return {
      'cardNumber': _cardNumber,
      'cardholderName': _cardholderName,
      'expiryDate': _expiryDate,
      'cvv': _securityCode,
      'paymentProductId': _paymentProductId,
    };
  }
}
