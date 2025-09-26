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
import 'package:flutter/material.dart';

/// Extension that returns a widget based on whether the object on which it was called is null. This helps avoid force unwrapping.
extension Ext<T> on T? {
  Widget runIfNotNull(Widget Function(T) action, {Widget? onNull}) {
    if (this != null) {
      return action(this as T);
    }
    return onNull ?? Container();
  }
}
