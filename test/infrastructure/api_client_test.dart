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

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:online_payments_sdk/src/domain/errors/communication_error.dart';
import 'package:online_payments_sdk/src/infrastructure/default_api_client.dart';
import 'package:online_payments_sdk/src/infrastructure/interfaces/device_information_provider.dart';
import 'package:online_payments_sdk/src/infrastructure/models/api_version.dart';
import 'package:online_payments_sdk/src/infrastructure/models/metadata.dart';

import '../helpers/test_http_client.dart';

class _MockDeviceInformationProvider implements DeviceInformationProvider {
  @override
  Metadata getMetadata() => const Metadata(
        screenSize: '1200x900',
        platformIdentifier: 'test-platform',
        sdkIdentifier: 'test-sdk-id',
        sdkCreator: 'test-creator',
        appIdentifier: '',
        deviceBrand: 'Apple',
        deviceType: 'iPhone',
      );
}

DefaultApiClient _buildClient(TestHttpClient httpClient) {
  return DefaultApiClient(
    clientApiUrl: 'https://api.test.com',
    customerId: 'customer123',
    clientSessionId: 'session456',
    deviceInformationProvider: _MockDeviceInformationProvider(),
    httpClient: httpClient,
  );
}

void main() {
  late TestHttpClient mockHttp;
  late DefaultApiClient apiClient;

  setUp(() {
    mockHttp = TestHttpClient();
    apiClient = _buildClient(mockHttp);
  });

  group('DefaultApiClient.get', () {
    test('sends GET request with correct URL structure', () async {
      mockHttp.setResponse(200, {'result': 'ok'});

      await apiClient.get('/crypto/publickey');

      expect(mockHttp.capturedRequests, hasLength(1));
      final uri = mockHttp.capturedRequests.first.url;
      expect(uri.path, contains('v1'));
      expect(uri.path, contains('customer123'));
      expect(uri.path, contains('crypto/publickey'));
    });

    test('includes Authorization header with clientSessionId', () async {
      mockHttp.setResponse(200, {});

      await apiClient.get('/some/path');

      final headers = mockHttp.capturedRequests.first.headers;
      expect(headers['Authorization'], equals('GCS v1Client:session456'));
    });

    test('includes X-GCS-ClientMetaInfo header', () async {
      mockHttp.setResponse(200, {});

      await apiClient.get('/some/path');

      final headers = mockHttp.capturedRequests.first.headers;
      expect(headers['X-GCS-ClientMetaInfo'], isNotNull);
      expect(headers['X-GCS-ClientMetaInfo'], isNotEmpty);
      final decoded = utf8.decode(base64Url.decode(
        base64Url.normalize(headers['X-GCS-ClientMetaInfo']!),
      ));
      final meta = jsonDecode(decoded) as Map<String, dynamic>;
      expect(meta['sdkIdentifier'], isNotEmpty);
    });

    test('returns successful SdkResponse', () async {
      final body = {'keyId': 'kid', 'publicKey': 'pk'};
      mockHttp.setResponse(200, body);

      final result = await apiClient.get('/crypto/publickey');

      expect(result.status, equals(200));
      expect(result.success, isTrue);
      expect(result.data, equals(body));
    });

    test('returns error SdkResponse for 4xx status', () async {
      mockHttp.setResponse(400, {'errorId': 'test'});

      final result = await apiClient.get('/some/path');

      expect(result.status, equals(400));
      expect(result.success, isFalse);
    });

    test('get_WhenResponseIs304_ReturnsSuccessfulSdkResponse', () async {
      mockHttp.setResponse(304, {});

      final result = await apiClient.get('/some/path');

      expect(result.status, equals(304));
      expect(result.success, isTrue);
    });

    test('throws CommunicationError on network failure', () async {
      mockHttp.setNetworkError();

      expect(
        () => apiClient.get('/some/path'),
        throwsA(isA<CommunicationError>()),
      );
    });

    test('throws CommunicationError on invalid JSON response', () async {
      mockHttp.setInvalidJsonResponse();

      expect(
        () => apiClient.get('/some/path'),
        throwsA(isA<CommunicationError>()),
      );
    });
  });

  group('DefaultApiClient.post', () {
    test('sends POST request with body', () async {
      mockHttp.setResponse(201, {'id': '123'});

      await apiClient.post('/create', body: jsonEncode({'data': 'test'}));

      expect(mockHttp.capturedRequests, hasLength(1));
      final request = mockHttp.capturedRequests.first as http.Request;
      expect(request.method, equals('POST'));
      expect(request.body, equals(jsonEncode({'data': 'test'})));
    });

    test('includes Content-Type header for POST', () async {
      mockHttp.setResponse(200, {});

      await apiClient.post('/create', body: '{}');

      final headers = mockHttp.capturedRequests.first.headers;
      expect(headers['Content-Type'], equals('application/json'));
      expect(headers['Authorization'], equals('GCS v1Client:session456'));
    });

    test('returns successful SdkResponse for POST', () async {
      mockHttp.setResponse(201, {'success': true});

      final result = await apiClient.post('/create', body: '{}');

      expect(result.status, equals(201));
      expect(result.success, isTrue);
    });
  });

  group('DefaultApiClient.getWithContext', () {
    test('appends query parameters to URL', () async {
      mockHttp.setResponse(200, {'products': []});

      await apiClient.getWithContext(
        '/products',
        queryParams: {'countryCode': 'US', 'amount': '1000', 'currencyCode': 'USD'},
      );

      final uri = mockHttp.capturedRequests.first.url;
      expect(uri.queryParameters['countryCode'], equals('US'));
      expect(uri.queryParameters['amount'], equals('1000'));
      expect(uri.queryParameters['currencyCode'], equals('USD'));
    });

    test('getWithContext_WithCacheBuster_AddsCacheBustQueryParam', () async {
      mockHttp.setResponse(200, {'products': []});

      await apiClient.getWithContext(
        '/products',
        queryParams: {'countryCode': 'US'},
        useCacheBuster: true,
      );

      final uri = mockHttp.capturedRequests.first.url;
      expect(uri.queryParameters.containsKey('cacheBust'), isTrue);
    });

    test('getWithContext_WithCustomApiVersion_UsesProvidedVersion', () async {
      mockHttp.setResponse(200, {'products': []});

      await apiClient.getWithContext(
        '/products',
        queryParams: {},
        apiVersion: ApiVersion.v2,
      );

      final uri = mockHttp.capturedRequests.first.url;
      expect(uri.path, contains('v2'));
      expect(uri.path, isNot(contains('v1')));
    });
  });

  group('DefaultApiClient.postWithContext', () {
    test('appends query parameters and sends body', () async {
      mockHttp.setResponse(200, {});

      await apiClient.postWithContext(
        '/payments',
        queryParams: {'countryCode': 'NL'},
        body: jsonEncode({'card': '4111111111111111'}),
      );

      final uri = mockHttp.capturedRequests.first.url;
      final request = mockHttp.capturedRequests.first as http.Request;
      expect(uri.queryParameters['countryCode'], equals('NL'));
      expect(request.body, equals(jsonEncode({'card': '4111111111111111'})));
    });
  });

  group('DefaultApiClient.getRequestHeaders', () {
    test('getRequestHeaders_WithAppIdentifier_IncludesAppIdentifierInClientMetaInfo', () async {
      mockHttp.setResponse(200, {});

      final client = DefaultApiClient(
        clientApiUrl: 'https://api.test.com',
        customerId: 'customer123',
        clientSessionId: 'session456',
        deviceInformationProvider: _MockDeviceInformationProvider(),
        httpClient: mockHttp,
        appIdentifier: 'my-test-app',
      );

      await client.get('/some/path');

      final headers = mockHttp.capturedRequests.first.headers;
      final metaInfo = headers['X-GCS-ClientMetaInfo']!;
      final decoded = utf8.decode(base64Url.decode(base64Url.normalize(metaInfo)));
      final meta = jsonDecode(decoded) as Map<String, dynamic>;
      expect(meta['appIdentifier'], equals('my-test-app'));
    });
  });
}
