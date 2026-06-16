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

import 'package:flutter_test/flutter_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/domain/sdk_response.dart';
import 'package:online_payments_sdk/src/infrastructure/interfaces/api_client.dart';
import 'package:online_payments_sdk/src/infrastructure/models/api_version.dart';
import 'package:online_payments_sdk/src/infrastructure/utils/cache_manager.dart';
import 'package:online_payments_sdk/src/services/base_service.dart';

class _TestBaseService extends BaseService {
  _TestBaseService() : super(CacheManager(), _NullApiClient());

  void callValidateResponse(SdkResponse<Map<String, dynamic>> response, String message) {
    validateResponse(response, message);
  }
}

class _NullApiClient implements ApiClient {
  @override
  Future<SdkResponse<Map<String, dynamic>>> get(String path, {Map<String, String>? headers, ApiVersion? apiVersion}) =>
      throw UnimplementedError();

  @override
  Future<SdkResponse<Map<String, dynamic>>> post(
    String path, {
    String? body,
    Map<String, String>? headers,
    ApiVersion? apiVersion,
  }) =>
      throw UnimplementedError();

  @override
  Future<SdkResponse<Map<String, dynamic>>> getWithContext(
    String path, {
    required Map<String, String> queryParams,
    Map<String, String>? headers,
    bool useCacheBuster = false,
    ApiVersion? apiVersion,
  }) =>
      throw UnimplementedError();

  @override
  Future<SdkResponse<Map<String, dynamic>>> postWithContext(
    String path, {
    required Map<String, String> queryParams,
    String? body,
    Map<String, String>? headers,
    bool useCacheBuster = false,
    ApiVersion? apiVersion,
  }) =>
      throw UnimplementedError();
}

void main() {
  late _TestBaseService service;

  setUp(() {
    service = _TestBaseService();
  });

  group('BaseService.validateResponse', () {
    test('validateResponse_SuccessfulResponseWithoutData_ThrowsResponseError', () {
      final response = SdkResponse<Map<String, dynamic>>(status: 200, success: true, data: {});

      expect(
        () => service.callValidateResponse(response, 'Something went wrong.'),
        throwsA(isA<ResponseError>().having((error) => error.message, 'message', 'Something went wrong.')),
      );
    });
  });
}
