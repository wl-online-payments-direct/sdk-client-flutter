/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2025 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

/// Utility class for dynamically fetching test credentials from the Worldline API.
/// This class handles the authentication and session creation required for integration tests.
class TestCredentials {
  // use the session details stored in the environment
  static String clientApiUrl = const String.fromEnvironment('clientApiUrl');
  static String assetUrl = const String.fromEnvironment('assetUrl');
  static String clientSessionId = const String.fromEnvironment('clientSessionId');
  static String customerId = const String.fromEnvironment('customerId');

  /// Fetches a new session credentials with the Worldline API using environment
  /// variables for authentication.
  /// 
  /// Required environment variables:
  /// - host: The Worldline API base URL
  /// - merchantId: The merchant identifier
  /// - apiKey: The API key for authentication
  /// - apiSecret: The API secret for HMAC signature generation
  static Future<void> get() async {
    const url = String.fromEnvironment('host');
    const merchantId = String.fromEnvironment('merchantId');
    const apiKey = String.fromEnvironment('apiKey');
    const apiSecret = String.fromEnvironment('apiSecret');

    assertValidGetParameters();

    // Construct the API endpoint for creating a session
    const path = '/v2/$merchantId/sessions';
    const apiEndpoint = '$url$path';

    final requestBody = jsonEncode({});

    // Generate timestamp for authentication in proper RFC 2822 format
    // Format current date in RFC1123 / HTTP format, GMT
    final now = DateTime.now().toUtc();
    final df = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US');
    final dateHeader = '${df.format(now)} GMT';

    const httpMethod = 'POST';
    const contentType = 'application/json; charset=utf-8';

    // Create the string to sign according to Worldline authentication spec
    final stringToSign = [httpMethod, contentType, dateHeader, path, ''].join('\n');

    // Create HMAC-SHA256 signature
    final key = utf8.encode(apiSecret);
    final bytes = utf8.encode(stringToSign);
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);
    final signature = base64.encode(digest.bytes);

    // Create authorization header
    final authHeader = 'GCS v1HMAC:$apiKey:$signature';

    try {
      // Make the API request
      final response = await http.post(
        Uri.parse(apiEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Date': dateHeader,
          'Authorization': authHeader,
        },
        body: requestBody,
      );

      if (response.statusCode == 201) {
        // Parse the response
        final responseData = jsonDecode(response.body);

        // Extract the session details from the response
        clientSessionId = responseData['clientSessionId'];
        customerId = responseData['customerId'];
        clientApiUrl = responseData['clientApiUrl'];
        assetUrl = responseData['assetUrl'];
      } else {
        throw Exception(
            'Failed to create session: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating test session: $e');
    }
  }

  /// Validates that all required environment variables are provided.
  /// Throws [StateError] if any required variables are missing.
  static void assertValidGetParameters() {
    final missing = <String>[];
    if (const String.fromEnvironment('host').isEmpty) {
      missing.add('host');
    }

    if (const String.fromEnvironment('merchantId').isEmpty) {
      missing.add('merchantId');
    }

    if (const String.fromEnvironment('apiKey').isEmpty) {
      missing.add('apiKey');
    }

    if (const String.fromEnvironment('apiSecret').isEmpty) {
      missing.add('apiSecret');
    }

    if (missing.isNotEmpty) {
      throw StateError('Missing environment variables: ${missing.join(', ')}');
    }
  }

  static void assertValid() {
    final missing = <String>[];
    if (clientApiUrl.isEmpty) {
      missing.add('clientApiUrl');
    }

    if (assetUrl.isEmpty) {
      missing.add('assetUrl');
    }

    if (clientSessionId.isEmpty) {
      missing.add('clientSessionId');
    }

    if (customerId.isEmpty) {
      missing.add('customerId');
    }

    if (missing.isNotEmpty) {
      throw StateError('Missing environment variables: ${missing.join(', ')}');
    }
  }
}