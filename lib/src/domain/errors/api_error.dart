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

import 'api_error_item.dart';

/// If an API error occurred during an API call, this object might be available on [ErrorResponse] and contains more information about the error that occurred.
class ApiError {
  String errorId;

  List<ApiErrorItem>? errors;

  ApiError(this.errorId, {required this.errors});

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
        json['errorId'] as String? ?? '',
        errors: (json['errors'] as List<dynamic>? ?? [])
            .map((e) => ApiErrorItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
