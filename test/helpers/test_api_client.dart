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

import 'package:online_payments_sdk/src/domain/sdk_response.dart';
import 'package:online_payments_sdk/src/infrastructure/interfaces/api_client.dart';
import 'package:online_payments_sdk/src/infrastructure/models/api_version.dart';

class TestApiClient implements ApiClient {
  Future<SdkResponse<Map<String, dynamic>>> Function(String path)? _mockGet;
  Future<SdkResponse<Map<String, dynamic>>> Function(String path)? _mockGetWithContext;
  Future<SdkResponse<Map<String, dynamic>>> Function(String path)? _mockPost;
  Future<SdkResponse<Map<String, dynamic>>> Function(String path)? _mockPostWithContext;

  /// The raw body string from the most recent [post] or [postWithContext] call.
  String? capturedPostBody;

  void setMockGet(Future<SdkResponse<Map<String, dynamic>>> Function(String) fn) => _mockGet = fn;

  void setMockGetWithContext(Future<SdkResponse<Map<String, dynamic>>> Function(String) fn) => _mockGetWithContext = fn;

  void setMockPost(Future<SdkResponse<Map<String, dynamic>>> Function(String) fn) => _mockPost = fn;

  void setMockPostWithContext(Future<SdkResponse<Map<String, dynamic>>> Function(String) fn) =>
      _mockPostWithContext = fn;

  @override
  Future<SdkResponse<Map<String, dynamic>>> get(String path, {Map<String, String>? headers, ApiVersion? apiVersion}) {
    if (_mockGet != null) return _mockGet!(path);
    throw UnimplementedError('TestApiClient.get not mocked for path: $path');
  }

  @override
  Future<SdkResponse<Map<String, dynamic>>> post(
    String path, {
    String? body,
    Map<String, String>? headers,
    ApiVersion? apiVersion,
  }) {
    capturedPostBody = body;
    if (_mockPost != null) return _mockPost!(path);
    throw UnimplementedError('TestApiClient.post not mocked for path: $path');
  }

  @override
  Future<SdkResponse<Map<String, dynamic>>> getWithContext(
    String path, {
    required Map<String, String> queryParams,
    Map<String, String>? headers,
    bool useCacheBuster = false,
    ApiVersion? apiVersion,
  }) {
    if (_mockGetWithContext != null) return _mockGetWithContext!(path);
    throw UnimplementedError('TestApiClient.getWithContext not mocked for path: $path');
  }

  @override
  Future<SdkResponse<Map<String, dynamic>>> postWithContext(
    String path, {
    required Map<String, String> queryParams,
    String? body,
    Map<String, String>? headers,
    bool useCacheBuster = false,
    ApiVersion? apiVersion,
  }) {
    capturedPostBody = body;
    if (_mockPostWithContext != null) return _mockPostWithContext!(path);
    throw UnimplementedError('TestApiClient.postWithContext not mocked for path: $path');
  }
}
