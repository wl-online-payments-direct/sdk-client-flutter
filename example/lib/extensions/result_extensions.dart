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
import 'package:online_payments_repository/models/result.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

/// Extension that processes a Result returned from the SDK. Based on whether the result was successful
/// or contains a [SdkError], the supplied callback is executed.
extension ProcessResultExtension<T> on Result<T> {
  void process({
    required Function(T) onData,
    required Function(SdkError) onError,
  }) {
    if (data != null) {
      onData(data as T);
    } else if (error != null) {
      onError(error!);
    }
  }
}
