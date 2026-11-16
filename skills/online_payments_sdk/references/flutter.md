# Flutter SDK reference

## Installation

```bash
flutter pub add online_payments_sdk
```

The SDK is written in Dart only; it has no native Android or iOS code of its own. It depends on
`http` and `pointycastle`, which are installed with it. It runs on Android, iOS and web.

The examples also use these packages. Add them to your app when you use that code:

- `http`: the calls to your backend in `examples/merchant_backend.dart`. Declare it in your own
  `pubspec.yaml` even though the SDK depends on it.
- `url_launcher`: opens the 3-D Secure redirect URL.
- `app_links`: receives the deep link when the customer returns to the app.

## Platform setup

- Android: the SDK makes network calls, so the app's `android/app/src/main/AndroidManifest.xml`
  must contain `<uses-permission android:name="android.permission.INTERNET" />`. Flutter adds it
  only to the debug and profile manifests, so a release build without it fails with a
  `CommunicationError`.
- Deep link for the return from 3-D Secure (see [flows.md](flows.md#10-handle-the-result)):
  - Choose a return URL that only your app handles, for example `myshop://payment-return`. Your
    backend sends it as the payment's `returnUrl` in Create Payment.
  - Android: add an `intent-filter` with `android.intent.action.VIEW`, the categories `DEFAULT` and
    `BROWSABLE`, and a `<data>` element with your scheme and host to the main activity.
  - iOS: register the scheme under `CFBundleURLTypes` in `ios/Runner/Info.plist`. For an https
    return URL use universal links (associated domains) instead.
  - Flutter's own deep link handling can take the link before `app_links` gets it. Turn it off as
    the `app_links` README describes: `flutter_deeplinking_enabled` set to `false` as `meta-data`
    of the main activity on Android, and `FlutterDeepLinkingEnabled` set to `false` in
    `Info.plist` on iOS.
  - Follow the `app_links` README for the complete platform setup.

## Imports

Everything is exported from one library:

<!-- region: initialise-sdk-import -->
```dart
import 'package:online_payments_sdk/online_payments_sdk.dart';
```

The SDK exports a class named `Card` (a card number for surcharge and currency conversion). It
clashes with Flutter's `Card` widget from `material.dart`. In files that use both, import one of
them with a prefix or with `hide`, for example
`import 'package:flutter/material.dart' hide Card;`.

## Async model

Every method that calls the Client API returns a `Future`. Use `async`/`await`. The SDK caches
payment products, IIN details, surcharge and currency conversion results and the public key for the
lifetime of the `OnlinePaymentSdk` instance, so create one instance per checkout and keep it in your
checkout state (for example in a `State` object or your state management). Call `sdk.dispose()`
when the checkout ends; it closes the HTTP client. Every network call times out after 30 seconds
with a `CommunicationError`.

Do not call SDK methods after `dispose()`. Check `mounted` before updating the UI after an `await`.

## SDK methods

`OnlinePaymentSdk(sessionData, {configuration, factory})` creates the SDK. `configuration` is an
`SdkConfiguration` with an optional `appIdentifier` (your app's name and version). `factory` is only
needed for Apple Pay (see [flows.md](flows.md#google-pay-and-apple-pay)); when you pass a factory,
the `configuration` parameter is ignored and must be passed to the factory instead.

| Method | Client API operation | Returns |
|---|---|---|
| `getBasicPaymentProducts(paymentContext)` | Get payment products | `BasicPaymentProducts` (`products`, `accountsOnFile`) |
| `getPaymentProduct(paymentProductId, paymentContext)` | Get payment product | `PaymentProduct` |
| `getPaymentProductNetworks(paymentProductId, paymentContext)` | Get payment product networks | `PaymentProductNetworksResponse` |
| `getIinDetails(partialCreditCardNumber, paymentContext)` | Get IIN details | `IinDetailsResponse` |
| `getSurchargeCalculation(amountOfMoney, cardSource)` | Surcharge calculation | `SurchargeCalculationResponse` |
| `getCurrencyConversionQuote(amountOfMoney, cardSource)` | Currency conversion quote | `CurrencyConversionResponse` |
| `encryptPaymentRequest(paymentRequest)` | Gets the public key, then encrypts on the device | `EncryptedRequest` |
| `encryptTokenRequest(tokenRequest)` | Gets the public key, then encrypts on the device | `EncryptedRequest` |
| `getPublicKey()` | Get public key | Used internally by the encrypt methods; do not use it to encrypt yourself |
| `dispose()` | None | Closes the HTTP client |

`cardSource` is a `CardSourceWithCard(Card(digits, paymentProductId: id))` for a card being
entered, or a `CardSourceWithToken(accountOnFile.id)` for a stored card.

`encodedClientMetaInfo` contains device information (screen size, platform, device brand and type) and the
`appIdentifier`. The SDK collects it; you only forward it.

## Domain objects

- `BasicPaymentProducts`: `products` (sorted by `displayOrder`), `accountsOnFile`,
  `getBasicPaymentProductById(id)`, `getBasicPaymentProductByAccountOnFileId(id)`.
- `PaymentProduct`: `fields`, `getField(id)`, `requiredFields`, `getAccountOnFile(id)`,
  `allowsTokenization`, `allowsRecurring`, `paymentProduct302SpecificData`,
  `paymentProduct320SpecificData`.
- `PaymentProductField`: `id`, `type`, `getLabel()`, `getPlaceholder()`, `isRequired()`,
  `shouldObfuscate()`, `getDisplayOrder()`, `applyMask(value)`, `removeMask(value)`,
  `validate(value)` (returns `List<ValidationErrorMessage>`).
- `PaymentRequest(paymentProduct: ..., accountOnFile: ..., tokenize: ...)`: `getField(id)`,
  `setValue(id, value)`, `getValue(id)`, `removeValue(id)`, `validate()` (returns
  `ValidationResult` with `isValid` and `errorMessages`), `accountOnFile`, `tokenize`.
- `PaymentRequestField`: `setValue()`, `getValue()`, `getMaskedValue()`, `validate()`.
- `AccountOnFile`: `id`, `paymentProductId`, `label`, `getValue(fieldId)`, `isWritable(fieldId)`.
- `ValidationErrorMessage`: `errorMessage` (English text), `paymentProductFieldId`, `rule`. To show
  your own translated texts, map `rule?.type` (`ValidationRuleType`) to your texts; `rule` is null
  for the "Field is required." error.

## Your backend

The examples call your own backend through the functions in `examples/merchant_backend.dart`. The
URL, paths and response shapes are placeholders; the SDK does not call them. The same file also has
`submitEncryptedToken` (tokenization).

Your backend:

- creates the client session with Create Session and returns `clientSessionId`, `customerId`,
  `clientApiUrl` and `assetUrl`. To show stored cards, it passes the customer's tokens to Create
  Session.
- creates the payment with Create Payment, passing `encryptedCustomerInput` and
  `encodedClientMetaInfo`, the order's amount, and `returnUrl` (your app's deep link) for 3-D
  Secure. With a currency conversion choice it sets
  `cardPaymentMethodSpecificInput.currencyConversion` to `{ dccSessionId, acceptedByUser }`. With
  surcharging it sets `order.surchargeSpecificInput.mode` to `on-behalf-of`.
- returns the redirect URL from the Create Payment response when there is one, and the status.
- returns the current payment status when the app asks after the customer came back.

<!-- region: merchant-backend -->
```dart
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
```
