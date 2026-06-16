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

import 'sdk_error.dart';

/// Thrown when an invalid argument is provided to an SDK method.
///
/// [data] can carry additional context (e.g. a partial [IinDetailsResponse]).
class InvalidArgumentError extends SdkError {
  final Object? metadata;

  const InvalidArgumentError(super.message, {this.metadata});
}
