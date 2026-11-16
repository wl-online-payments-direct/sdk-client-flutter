/// Calls from the app to the merchant's own backend. The URL, endpoint paths and response shapes are
/// placeholders: replace them with your own. The SDK is not involved in these calls.
library;

// [START merchant-backend]
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:online_payments_sdk/online_payments_sdk.dart';

const _backendUrl = 'https://shop.example.com';

/// The payment status as your backend reports it.
enum PaymentStatus { success, pending, failed }

/// What your backend returns after it has created the payment, or when the app asks for the status.
class MerchantPaymentResponse {
  /// Set when the customer must be redirected, for example for 3-D Secure.
  final String? redirectUrl;
  final PaymentStatus status;

  MerchantPaymentResponse({required this.status, this.redirectUrl});

  factory MerchantPaymentResponse.fromJson(Map<String, dynamic> json) => MerchantPaymentResponse(
        redirectUrl: json['redirectUrl'] as String?,
        status: PaymentStatus.values.byName((json['status'] as String).toLowerCase()),
      );
}

class MerchantBackendException implements Exception {
  final String path;
  final int statusCode;

  MerchantBackendException(this.path, this.statusCode);

  @override
  String toString() => 'MerchantBackendException: $path failed with HTTP $statusCode';
}

Future<Map<String, dynamic>> _postJson(String path, [Map<String, Object?>? body]) async {
  final response = await http.post(
    Uri.parse('$_backendUrl$path'),
    headers: {'Content-Type': 'application/json'},
    body: body == null ? null : jsonEncode(body),
  );
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw MerchantBackendException(path, response.statusCode);
  }
  return jsonDecode(response.body) as Map<String, dynamic>;
}

/// Your backend creates a new client session for this checkout and returns its data.
Future<SessionData> fetchSessionData() async {
  final json = await _postJson('/api/checkout/session');
  return SessionData(
    clientSessionId: json['clientSessionId'] as String,
    customerId: json['customerId'] as String,
    clientApiUrl: json['clientApiUrl'] as String,
    assetUrl: json['assetUrl'] as String,
  );
}

/// The customer's currency conversion choice. Your backend passes both fields to Create Payment in
/// cardPaymentMethodSpecificInput.currencyConversion. Both are mandatory once a quote was shown.
class CurrencyConversionChoice {
  final String dccSessionId;

  /// true: pay in the card's currency (proposal.targetAmount); false: pay in your currency.
  final bool acceptedByUser;

  CurrencyConversionChoice({required this.dccSessionId, required this.acceptedByUser});

  Map<String, Object?> toJson() => {'dccSessionId': dccSessionId, 'acceptedByUser': acceptedByUser};
}

/// Your backend creates the payment for the order with the encrypted customer input.
Future<MerchantPaymentResponse> submitEncryptedPayment(
  String orderId,
  EncryptedRequest encryptedRequest, {
  CurrencyConversionChoice? currencyConversion, // only when a currency conversion offer was shown
}) async {
  final json = await _postJson('/api/checkout/payment', {
    'orderId': orderId,
    'encryptedCustomerInput': encryptedRequest.encryptedCustomerInput,
    'encodedClientMetaInfo': encryptedRequest.encodedClientMetaInfo,
    if (currencyConversion != null) 'currencyConversion': currencyConversion.toJson(),
  });
  return MerchantPaymentResponse.fromJson(json);
}

/// Your backend reads the payment status, for example after the customer returns from 3-D Secure.
Future<MerchantPaymentResponse> fetchPaymentStatus(String orderId) async {
  final json = await _postJson('/api/checkout/status', {'orderId': orderId});
  return MerchantPaymentResponse.fromJson(json);
}
// [END merchant-backend]

/// Your backend creates the token with the encrypted card data.
Future<String> submitEncryptedToken(EncryptedRequest encryptedRequest) async {
  final json = await _postJson('/api/tokens', {
    'encryptedCustomerInput': encryptedRequest.encryptedCustomerInput,
    'encodedClientMetaInfo': encryptedRequest.encodedClientMetaInfo,
  });
  return json['token'] as String;
}
