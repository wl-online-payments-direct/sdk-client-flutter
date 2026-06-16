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

import '../../domain/sdk_response.dart';
import '../models/api_version.dart';

/// Abstract interface for all HTTP API calls to the Worldline Online Payments API.
abstract class ApiClient {
  /// Performs a GET request on [path] with optional extra [headers].
  Future<SdkResponse<Map<String, dynamic>>> get(
    String path, {
    Map<String, String>? headers,
    ApiVersion? apiVersion,
  });

  /// Performs a POST request on [path] with optional [body] and [headers].
  Future<SdkResponse<Map<String, dynamic>>> post(
    String path, {
    String? body,
    Map<String, String>? headers,
    ApiVersion? apiVersion,
  });

  /// Performs a GET request with payment [context] query parameters appended.
  Future<SdkResponse<Map<String, dynamic>>> getWithContext(
    String path, {
    required Map<String, String> queryParams,
    Map<String, String>? headers,
    bool useCacheBuster = false,
    ApiVersion? apiVersion,
  });

  /// Performs a POST request with payment [context] query parameters appended.
  Future<SdkResponse<Map<String, dynamic>>> postWithContext(
    String path, {
    required Map<String, String> queryParams,
    String? body,
    Map<String, String>? headers,
    bool useCacheBuster = false,
    ApiVersion? apiVersion,
  });
}
