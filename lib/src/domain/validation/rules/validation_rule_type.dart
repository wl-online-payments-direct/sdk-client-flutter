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

/// Enum containing all possible [ValidationRule] types.
enum ValidationRuleType {
  expirationDate,
  emailAddress,
  fixedList,
  iban,
  length,
  luhn,
  range,
  regularExpression,
  required,
  type,
  termsAndConditions;

  static const expirationDateKey = 'EXPIRATIONDATE';
  static const emailAddressKey = 'EMAILADDRESS';
  static const fixedListKey = 'FIXEDLIST';
  static const ibanKey = 'IBAN';
  static const lengthKey = 'LENGTH';
  static const luhnKey = 'LUHN';
  static const rangeKey = 'RANGE';
  static const regularExpressionKey = 'REGULAREXPRESSION';
  static const requiredKey = 'REQUIRED';
  static const typeKey = 'TYPE';
  static const termsAndConditionsKey = 'TERMSANDCONDITIONS';
}
