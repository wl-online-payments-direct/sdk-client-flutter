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
import 'package:online_payments_sdk/online_payments_sdk.dart';

import 'test_credentials.dart';
import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await TestCredentials.get();
  });

  group('sdk.encryptTokenRequest', () {
    late OnlinePaymentSdk sdk;

    setUp(() => sdk = TestHelpers.createSdk());
    tearDown(() => sdk.dispose());

    test('encryptTokenRequest_WhenProductIdNotSet_ThrowsSdkError', () async {
      final request = CreditCardTokenRequest();
      request.setCardNumber('4242424242424242');

      await expectLater(
            () => sdk.encryptTokenRequest(request),
        throwsA(isA<SdkError>()),
      );
    });

    test('encryptTokenRequest_WithInvalidData_StillProducesEncryptedOutput', () async {
      final request = CreditCardTokenRequest();
      request.setPaymentProductId(1);
      request.setCardNumber('4567350000427977');
      // no cardholderName, expiryDate, or securityCode set

      final result = await sdk.encryptTokenRequest(request);

      expect(result.encryptedCustomerInput, isNotEmpty);
      expect(result.encryptedCustomerInput, isA<String>());
      expect(result.encryptedCustomerInput.split('.'), hasLength(5));
    });

    test('encryptTokenRequest_WithValidData_ReturnsEncryptedOutput', () async {
      final request = CreditCardTokenRequest();
      request.setPaymentProductId(1);
      request.setCardNumber('4567350000427977');
      request.setCardholderName('Test User');
      request.setExpiryDate('1236');
      request.setSecurityCode('123');

      final result = await sdk.encryptTokenRequest(request);

      expect(result.encryptedCustomerInput, isNotEmpty);
      expect(result.encryptedCustomerInput, isA<String>());
      expect(result.encryptedCustomerInput.split('.'), hasLength(5));
    });

    test('encryptTokenRequest_ReturnsEncryptedTokenAsString', () async {
      final request = CreditCardTokenRequest();
      request.setPaymentProductId(1);
      request.setCardNumber('4567350000427977');
      request.setCardholderName('Test User');
      request.setExpiryDate('1236');
      request.setSecurityCode('123');

      final result = await sdk.encryptTokenRequest(request);

      expect(result.encryptedCustomerInput, isA<String>());
      expect(result.encryptedCustomerInput.length, greaterThan(0));
    });

    test('encryptTokenRequest_GetValues_WithAllFieldsSet_ReturnsCorrectFieldsMap', () async {
      final request = CreditCardTokenRequest();
      request.setPaymentProductId(1);
      request.setCardNumber('4567350000427977');
      request.setCardholderName('Test User');
      request.setExpiryDate('1236');
      request.setSecurityCode('123');

      final values = request.getValues();

      expect(values['cardNumber'], equals('4567350000427977'));
      expect(values['cardholderName'], equals('Test User'));
      expect(values['expiryDate'], equals('1236'));
      expect(values['cvv'], equals('123'));
      expect(values['paymentProductId'], equals(1));
    });

    test('encryptTokenRequest_ReturnsEncodedClientMetaInfo', () async {
      final request = CreditCardTokenRequest();
      request.setPaymentProductId(1);
      request.setCardNumber('4567350000427977');

      final result = await sdk.encryptTokenRequest(request);

      expect(result.encodedClientMetaInfo, isNotEmpty);
    });

    test('encryptTokenRequest_ReturnsDecodableEncodedClientMetaInfo', () async {
      final request = CreditCardTokenRequest();
      request.setPaymentProductId(1);
      request.setCardNumber('4567350000427977');

      final result = await sdk.encryptTokenRequest(request);

      expect(result.encodedClientMetaInfo, isNotNull);
      expect(result.encodedClientMetaInfo, isNotEmpty);

      final decodedMetadata = jsonDecode(_decodeBase64Url(result.encodedClientMetaInfo!)) as Map<String, dynamic>;

      expect(decodedMetadata['screenSize'], isA<String>());
      expect(decodedMetadata['platformIdentifier'], isA<String>());
      expect(decodedMetadata['sdkIdentifier'], isA<String>());
      expect(decodedMetadata['sdkCreator'], isA<String>());
      expect(decodedMetadata['appIdentifier'], equals('FlutterSDKIntegrationTest/2.0.0'));
      expect(decodedMetadata['deviceBrand'], isA<String>());
      expect(decodedMetadata['deviceType'], isA<String>());
    });
  });

  group('Server Api create token', () {
    late OnlinePaymentSdk sdk;

    setUp(() => sdk = TestHelpers.createSdk());
    tearDown(() => sdk.dispose());

    test('createToken_WithValidTokenRequestData_Succeeds', () async {
      final request = CreditCardTokenRequest();
      request.setPaymentProductId(1);
      request.setCardNumber('4567350000427977');
      request.setCardholderName('Test User');
      request.setExpiryDate('1236');
      request.setSecurityCode('123');

      final encryptedTokenRequest = await sdk.encryptTokenRequest(request);

      final response = await _createTokenFromServerApi(
        encryptedCustomerInput: encryptedTokenRequest.encryptedCustomerInput,
        paymentProductId: 1,
      );

      expect(response.statusCode, anyOf(equals(200), equals(201)), reason: response.body);

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      expect(responseData['token'], isA<String>());
      expect(responseData['token'], isNotEmpty);
      expect(responseData['isNewToken'], isNotNull);
    });

    test('createToken_WithInvalidTokenRequestData_Fails', () async {
      final response = await _createTokenFromServerApi(
        encryptedCustomerInput: 'invalid-encrypted-customer-input',
        paymentProductId: 1,
      );

      expect(response.statusCode, equals(400), reason: response.body);

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      expect(responseData['errorId'], isA<String>());
      expect(responseData['errors'], isA<List>());
      expect(responseData['errors'], isNotEmpty);
    });
  });
}

String _decodeBase64Url(String value) {
  return utf8.decode(base64Url.decode(base64Url.normalize(value)));
}

Future<http.Response> _createTokenFromServerApi({
  required String encryptedCustomerInput,
  required int paymentProductId,
}) {
  const merchantId = String.fromEnvironment('merchantId');

  final requestBody = jsonEncode({
    'encryptedCustomerInput': encryptedCustomerInput,
    'paymentProductId': paymentProductId,
  });

  return _signedPost(
    path: '/v2/$merchantId/tokens',
    body: requestBody,
  );
}

Future<http.Response> _signedPost({
  required String path,
  required String body,
}) async {
  const host = String.fromEnvironment('host');
  const apiKey = String.fromEnvironment('apiKey');
  const apiSecret = String.fromEnvironment('apiSecret');

  TestCredentials.assertValidGetParameters();

  final apiEndpoint = '${host.replaceAll(RegExp(r'/$'), '')}$path';

  const httpMethod = 'POST';
  const contentType = 'application/json; charset=utf-8';

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
    body: body,
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