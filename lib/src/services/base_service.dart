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

import '../domain/errors/api_error.dart';
import '../domain/errors/response_error.dart';
import '../domain/sdk_response.dart';
import '../infrastructure/interfaces/api_client.dart';
import '../infrastructure/utils/cache_manager.dart';

/// Base class for all SDK services, providing shared [apiClient], [cacheManager], and [validateResponse].
abstract class BaseService {
  final CacheManager cacheManager;
  final ApiClient apiClient;

  BaseService(this.cacheManager, this.apiClient);

  /// Throws [ResponseError] if [response] indicates a failure or contains no data.
  void validateResponse(SdkResponse<Map<String, dynamic>> response, String errorMessage) {
    if (!response.success) {
      final apiError = response.data.isNotEmpty ? ApiError.fromJson(response.data) : null;
      throw ResponseError(errorMessage, statusCode: response.status, apiError: apiError);
    }

    if (response.data.isEmpty) {
      throw ResponseError(errorMessage, statusCode: response.status);
    }
  }
}
