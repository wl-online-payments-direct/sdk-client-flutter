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

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/errors/communication_error.dart';
import '../domain/sdk_response.dart';
import 'interfaces/api_client.dart';
import 'interfaces/device_information_provider.dart';
import 'models/api_version.dart';
import 'utils/url_util.dart';
import 'utils/util.dart';

/// Default HTTP client for the Worldline Online Payments API.
///
/// Adds the required [Authorization] and [X-GCS-ClientMetaInfo] headers to every request.
class DefaultApiClient implements ApiClient {
  final String _clientApiUrl;
  final String _customerId;
  final String _clientSessionId;
  final DeviceInformationProvider _deviceInformationProvider;
  final String? _appIdentifier;
  final ApiVersion _defaultApiVersion;

  final http.Client _httpClient;

  DefaultApiClient({
    required String clientApiUrl,
    required String customerId,
    required String clientSessionId,
    required DeviceInformationProvider deviceInformationProvider,
    String? appIdentifier,
    ApiVersion defaultApiVersion = ApiVersion.v1,
    http.Client? httpClient,
  })  : _clientApiUrl = clientApiUrl,
        _customerId = customerId,
        _clientSessionId = clientSessionId,
        _deviceInformationProvider = deviceInformationProvider,
        _appIdentifier = appIdentifier,
        _defaultApiVersion = defaultApiVersion,
        _httpClient = httpClient ?? http.Client();

  @override
  Future<SdkResponse<Map<String, dynamic>>> get(
    String path, {
    Map<String, String>? headers,
    ApiVersion? apiVersion,
  }) async {
    final url = _buildUrl(path, apiVersion ?? _defaultApiVersion);
    final response = await _execute(() => _httpClient.get(Uri.parse(url), headers: _buildHeaders(headers)));
    return _parseResponse(response);
  }

  @override
  Future<SdkResponse<Map<String, dynamic>>> post(
    String path, {
    String? body,
    Map<String, String>? headers,
    ApiVersion? apiVersion,
  }) async {
    final url = _buildUrl(path, apiVersion ?? _defaultApiVersion);
    final mergedHeaders = {
      ..._buildHeaders(headers),
      'Content-Type': 'application/json',
    };
    final response = await _execute(() => _httpClient.post(Uri.parse(url), headers: mergedHeaders, body: body));
    return _parseResponse(response);
  }

  @override
  Future<SdkResponse<Map<String, dynamic>>> getWithContext(
    String path, {
    required Map<String, String> queryParams,
    Map<String, String>? headers,
    bool useCacheBuster = false,
    ApiVersion? apiVersion,
  }) async {
    final allParams = {...queryParams, if (useCacheBuster) 'cacheBust': '${DateTime.now().millisecondsSinceEpoch}'};
    final baseUrl = _buildUrl(path, apiVersion ?? _defaultApiVersion);
    final url = UrlUtil.urlWithQueryString(baseUrl, allParams);
    final response = await _execute(() => _httpClient.get(Uri.parse(url), headers: _buildHeaders(headers)));
    return _parseResponse(response);
  }

  @override
  Future<SdkResponse<Map<String, dynamic>>> postWithContext(
    String path, {
    required Map<String, String> queryParams,
    String? body,
    Map<String, String>? headers,
    bool useCacheBuster = false,
    ApiVersion? apiVersion,
  }) async {
    final allParams = {...queryParams, if (useCacheBuster) 'cacheBust': '${DateTime.now().millisecondsSinceEpoch}'};
    final baseUrl = _buildUrl(path, apiVersion ?? _defaultApiVersion);
    final url = UrlUtil.urlWithQueryString(baseUrl, allParams);
    final mergedHeaders = {
      ..._buildHeaders(headers),
      'Content-Type': 'application/json',
    };
    final response = await _execute(() => _httpClient.post(Uri.parse(url), headers: mergedHeaders, body: body));
    return _parseResponse(response);
  }

  String _buildUrl(String path, ApiVersion version) {
    return UrlUtil.segmentsToPath([_clientApiUrl, version.value, _customerId, path]);
  }

  Map<String, String> _buildHeaders(Map<String, String>? extra) {
    final metadata = Util.getMetadata(provider: _deviceInformationProvider, appIdentifier: _appIdentifier);
    final metaJson = jsonEncode(metadata.toJson());
    return {
      'Authorization': 'GCS v1Client:$_clientSessionId',
      'X-GCS-ClientMetaInfo': Util.base64UrlEncode(metaJson),
      'Accept': 'application/json',
      if (extra != null) ...extra,
    };
  }

  SdkResponse<Map<String, dynamic>> _parseResponse(http.Response response) {
    final status = response.statusCode;
    final success = (status >= 200 && status < 300) || status == 304;
    final body = response.body;

    if (body.isEmpty) {
      return SdkResponse(status: status, success: success, data: {});
    }

    final contentType = response.headers['content-type'] ?? '';
    if (!contentType.contains('application/json')) {
      throw CommunicationError(
        'Unexpected response content type: $contentType',
        statusCode: status,
      );
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(body);
    } catch (_) {
      throw CommunicationError('Invalid JSON response from server', statusCode: status);
    }

    if (decoded is! Map<String, dynamic>) {
      throw CommunicationError('Unexpected response format: expected JSON object', statusCode: status);
    }

    return SdkResponse(status: status, success: success, data: decoded);
  }

  Future<http.Response> _execute(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(const Duration(seconds: 30));
    } on TimeoutException {
      throw CommunicationError('Network request timed out');
    } catch (e) {
      throw CommunicationError('Network request failed', cause: e);
    }
  }

  /// Closes the underlying HTTP client. Call this when the SDK is no longer needed.
  void close() => _httpClient.close();
}
