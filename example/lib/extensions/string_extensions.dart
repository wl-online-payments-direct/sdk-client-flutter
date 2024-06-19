/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2024 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import 'package:online_payments_repository/strings.dart' as strings;

extension NullEmptyValidation on String? {
  /// Extension that checks if this String is null or empty
  bool _isEmptyOrNull() {
    return this?.isEmpty ?? true;
  }

  /// Extension that validates whether an optional String is null or empty. If null or empty, it will return a validation message.
  String? validateNullOrEmpty() {
    if (_isEmptyOrNull()) {
      return strings.emptyFieldValidationMessage;
    }

    return null;
  }
}
