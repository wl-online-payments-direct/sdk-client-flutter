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
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/facade/session_data_normalizer.dart';

import 'test_credentials.dart';

/// An HTTP client that forwards all requests to a real [inner] client while
/// counting the number of network calls made. Use [callCount] to assert that
/// the cache prevented redundant API requests.
class CountingHttpClient extends http.BaseClient {
  final http.Client _inner;
  int callCount = 0;

  CountingHttpClient() : _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    callCount++;
    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}

/// Creates an [OnlinePaymentSdk] wired with a [CountingHttpClient].
/// Returns both the SDK and the client so call counts can be asserted.
///
/// Session data is normalized (e.g. `/client` path is appended to [clientApiUrl]
/// when absent) to match what [OnlinePaymentSdk] does internally when no
/// explicit factory is provided.
class StubHttpClient extends http.BaseClient {
  final Future<http.Response> Function(http.BaseRequest request) _handler;

  StubHttpClient(this._handler);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await _handler(request);
    final stream = http.ByteStream(Stream.value(response.bodyBytes));

    return http.StreamedResponse(
      stream,
      response.statusCode,
      request: request,
      headers: response.headers,
      reasonPhrase: response.reasonPhrase,
    );
  }
}

class FailingHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    throw Exception('Simulated network failure');
  }
}

(OnlinePaymentSdk, CountingHttpClient) createSdkWithCounter() {
  final counter = CountingHttpClient();
  final sessionData = normalizeSessionData(TestCredentials.createSessionData());

  final sdk = OnlinePaymentSdk(
    sessionData,
    factory: DefaultServiceFactory(
      sessionData,
      httpClient: counter,
      configuration: const SdkConfiguration(appIdentifier: 'FlutterSDKIntegrationTest/2.0.0'),
    ),
  );

  return (sdk, counter);
}

OnlinePaymentSdk createSdkWithHttpClient(http.Client httpClient) {
  final sessionData = normalizeSessionData(
    SessionData(
      clientSessionId: 'test-client-session-id',
      customerId: '9991',
      clientApiUrl: 'https://example.com/client',
      assetUrl: 'https://example.com/assets',
    ),
  );

  return OnlinePaymentSdk(
    sessionData,
    factory: DefaultServiceFactory(
      sessionData,
      httpClient: httpClient,
      configuration: const SdkConfiguration(appIdentifier: 'FlutterSDKIntegrationTest/2.0.0'),
    ),
  );
}

http.Response jsonResponse(int statusCode, Map<String, dynamic> body) {
  return http.Response(
    jsonEncode(body),
    statusCode,
    headers: {'content-type': 'application/json'},
  );
}

Map<String, dynamic> apiErrorResponse({
  required int statusCode,
  required String errorCode,
  required String message,
  String? propertyName,
}) {
  return {
    'errorId': 'test-error-id',
    'errors': [
      {
        'errorCode': errorCode,
        'httpStatusCode': statusCode,
        'message': message,
        if (propertyName != null) 'propertyName': propertyName,
      },
    ],
  };
}

class TestHelpers {
  /// Creates an [OnlinePaymentSdk] instance using the current test credentials.
  static OnlinePaymentSdk createSdk() {
    return OnlinePaymentSdk(
      TestCredentials.createSessionData(),
      configuration: const SdkConfiguration(appIdentifier: 'FlutterSDKIntegrationTest/2.0.0'),
    );
  }

  /// Creates a standard [PaymentContext] for testing.
  static PaymentContext createTestPaymentContext({
    int amountInCents = 1000,
    String currencyCode = 'EUR',
    String countryCode = 'NL',
    bool isRecurring = false,
  }) {
    return PaymentContext(
      AmountOfMoney(amountInCents, currencyCode),
      countryCode,
      isRecurring: isRecurring,
    );
  }

  /// Fetches a [PaymentProduct] by [productId] and returns it.
  static Future<PaymentProduct> getPaymentProduct(
      OnlinePaymentSdk sdk,
      int productId, {
        PaymentContext? paymentContext,
      }) async {
    final product = await sdk.getPaymentProduct(
      productId,
      paymentContext ?? createTestPaymentContext(),
    );

    expect(product, isNotNull);

    return product;
  }

  /// Creates a [PaymentRequest] pre-filled with valid test card values.
  static PaymentRequest createTestPaymentRequest(PaymentProduct paymentProduct) {
    final request = PaymentRequest(paymentProduct: paymentProduct);

    createTestFieldValues(paymentProduct).forEach((key, value) {
      request.setValue(key, value);
    });

    return request;
  }

  /// Returns a map of valid test field values for the given [paymentProduct].
  static Map<String, String> createTestFieldValues(PaymentProduct paymentProduct) {
    return {
      'cardNumber': '4330264936344675',
      'expiryDate': _getExpiryDateForMask(paymentProduct),
      'cvv': '123',
      'cardholderName': 'John Doe',
    };
  }

  /// Asserts that all required fields have at least one validation error when empty.
  static void expectRequiredFieldValidationErrors(
      ValidationResult result,
      PaymentProduct paymentProduct,
      ) {
    for (final field in paymentProduct.fields) {
      if (field.dataRestrictions.isRequired) {
        expect(
          result.errorMessages.where((errorMessage) => errorMessage.paymentProductFieldId == field.id).isNotEmpty,
          isTrue,
          reason: "Required field '${field.id}' should have validation error when empty",
        );
      }
    }
  }

  /// Asserts that the [result] contains no validation errors.
  static void expectNoValidationErrors(ValidationResult result) {
    expect(
      result.errorMessages,
      isEmpty,
      reason: 'Valid request should have no validation errors',
    );
  }

  /// Asserts that the [result] contains at least one validation error.
  static void expectValidationErrors(ValidationResult result) {
    expect(
      result.errorMessages,
      isNotEmpty,
      reason: 'Invalid request should have validation errors',
    );
  }

  static String _getExpiryDateForMask(
      PaymentProduct paymentProduct, {
        String shortDate = '1228',
        String longDate = '122028',
      }) {
    final expiryDateField = paymentProduct.fields.firstWhere(
          (field) => field.id == 'expiryDate',
      orElse: () => throw Exception('No expiryDate field found'),
    );

    final mask = expiryDateField.displayHints?.mask ?? '{{99}}/{{99}}';
    final nineCount = mask.split('').where((char) => char == '9').length;

    return nineCount == 4 ? shortDate : longDate;
  }
}

