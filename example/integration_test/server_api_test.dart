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

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';
import 'package:intl/intl.dart';

import 'test_credentials.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Server Api', () {
    test('serverApiSession_ReturnsValidSessionCredentials', () async {
      await TestCredentials.get();

      TestCredentials.assertValid();

      final sessionData = TestCredentials.createSessionData();

      expect(sessionData.clientSessionId, isNotEmpty);
      expect(sessionData.customerId, isNotEmpty);
      expect(sessionData.clientApiUrl, isNotEmpty);
      expect(sessionData.assetUrl, isNotEmpty);
    });

    test('serverApiSignatureGeneration_CreatesSessionWithSignedRequest', () async {
      final response = await _createSessionWithSignedRequest();

      expect(response.statusCode, equals(201), reason: response.body);

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      expect(responseData['clientSessionId'], isA<String>());
      expect(responseData['clientSessionId'], isNotEmpty);
      expect(responseData['customerId'], isA<String>());
      expect(responseData['customerId'], isNotEmpty);
      expect(responseData['clientApiUrl'], isA<String>());
      expect(responseData['clientApiUrl'], isNotEmpty);
      expect(responseData['assetUrl'], isA<String>());
      expect(responseData['assetUrl'], isNotEmpty);
    });
  });
}

Future<http.Response> _createSessionWithSignedRequest() async {
  const host = String.fromEnvironment('host');
  const merchantId = String.fromEnvironment('merchantId');
  const apiKey = String.fromEnvironment('apiKey');
  const apiSecret = String.fromEnvironment('apiSecret');

  TestCredentials.assertValidGetParameters();

  const path = '/v2/$merchantId/sessions';
  final apiEndpoint = '${host.replaceAll(RegExp(r'/$'), '')}$path';

  const httpMethod = 'POST';
  const contentType = 'application/json; charset=utf-8';
  const requestBody = '{}';

  final now = DateTime.now().toUtc();
  final dateFormat = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US');
  final dateHeader = '${dateFormat.format(now)} GMT';

  final authorizationHeader = _createAuthorizationHeader(
    apiKey: apiKey,
    apiSecret: apiSecret,
    httpMethod: httpMethod,
    contentType: contentType,
    dateHeader: dateHeader,
    path: path,
  );

  return http.post(
    Uri.parse(apiEndpoint),
    headers: {
      'Content-Type': contentType,
      'Date': dateHeader,
      'Authorization': authorizationHeader,
    },
    body: requestBody,
  );
}

String _createAuthorizationHeader({
  required String apiKey,
  required String apiSecret,
  required String httpMethod,
  required String contentType,
  required String dateHeader,
  required String path,
}) {
  final stringToSign = [httpMethod, contentType, dateHeader, path, ''].join('\n');

  final key = utf8.encode(apiSecret);
  final bytes = utf8.encode(stringToSign);
  final hmacSha256 = Hmac(sha256, key);
  final digest = hmacSha256.convert(bytes);
  final signature = base64.encode(digest.bytes);

  return 'GCS v1HMAC:$apiKey:$signature';
}