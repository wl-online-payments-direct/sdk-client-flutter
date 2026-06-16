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

import 'api_error.dart';

/// Represents an error response from the Worldline API.
class ErrorResponse {
  final String errorId;

  final List<ApiError> errors;

  ErrorResponse({required this.errorId, this.errors = const []});
}
