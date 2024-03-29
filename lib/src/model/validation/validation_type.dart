/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2023 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import 'package:json_annotation/json_annotation.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

/// Enum containing all possible [ValidationRule] types.
enum ValidationType {
  @JsonValue(expirationDateKey)
  expirationDate,
  @JsonValue(emailAddressKey)
  emailAddress,
  @JsonValue(fixedListKey)
  fixedList,
  @JsonValue(ibanKey)
  iban,
  @JsonValue(lengthKey)
  length,
  @JsonValue(luhnKey)
  luhn,
  @JsonValue(rangeKey)
  range,
  @JsonValue(regularExpressionKey)
  regularExpression,
  @JsonValue(requiredKey)
  required,
  @JsonValue(typeKey)
  type,
  @JsonValue(termsAndConditionsKey)
  termsAndConditions;

  static const expirationDateKey = "EXPIRATIONDATE";
  static const emailAddressKey = "EMAILADDRESS";
  static const fixedListKey = "FIXEDLIST";
  static const ibanKey = "IBAN";
  static const lengthKey = "LENGTH";
  static const luhnKey = "LUHN";
  static const rangeKey = "RANGE";
  static const regularExpressionKey = "REGULAREXPRESSION";
  static const requiredKey = "REQUIRED";
  static const typeKey = "TYPE";
  static const termsAndConditionsKey = "TERMSANDCONDITIONS";
}
