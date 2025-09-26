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

/// Enum containing all the possible statuses of a [IinDetailsResponse].
enum IinStatus {
  @JsonValue("SUPPORTED")
  supported,
  @JsonValue("UNKNOWN")
  unknown,
  @JsonValue("NOT_ENOUGH_DIGITS")
  notEnoughDigits,
  @JsonValue("EXISTING_BUT_NOT_ALLOWED")
  existingButNotAllowed
}
