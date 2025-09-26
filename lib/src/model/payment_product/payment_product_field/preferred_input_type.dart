/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2025 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import 'package:json_annotation/json_annotation.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

/// Enum containing all the possible keyboard types required to fill in a value of a [PaymentProductField].
enum PreferredInputType {
  @JsonValue("IntegerKeyboard")
  integerKeyboard,
  @JsonValue("StringKeyboard")
  stringKeyboard,
  @JsonValue("PhoneNumberKeyboard")
  phoneNumberKeyboard,
  @JsonValue("EmailAddressKeyboard")
  emailAddressKeyboard,
  @JsonValue("DateKeyboard")
  datePicker,
}
