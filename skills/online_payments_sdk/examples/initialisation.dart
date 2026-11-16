// [START initialise-sdk-import]
import 'package:online_payments_sdk/online_payments_sdk.dart';
// [END initialise-sdk-import]

import 'merchant_backend.dart';

// [START initialise-sdk]
Future<OnlinePaymentSdk> createSdk() async {
  // New session data for every checkout. Your backend creates it with Create Session.
  // The session data holds no secret: never put the API key or secret in the app.
  final sessionData = await fetchSessionData();

  // Throws a ConfigurationError when a value is empty or clientApiUrl has a path other than
  // "" or "/client".
  return OnlinePaymentSdk(
    sessionData,
    configuration: const SdkConfiguration(appIdentifier: 'MyShopApp/1.0.0'),
  );
}
// [END initialise-sdk]

// [START dispose-sdk]
// Call when the checkout ends (paid, cancelled or restarted with new session data), for example
// in the checkout screen's dispose(). It closes the SDK's HTTP client.
void endCheckout(OnlinePaymentSdk sdk) {
  sdk.dispose();
}
// [END dispose-sdk]

// [START payment-context]
PaymentContext createPaymentContext({
  required int totalInMinorUnits,
  required String currencyCode,
  required String countryCode,
}) {
  // Use the real values of the order being paid: the payment products, surcharge and
  // currency conversion returned by the SDK depend on them.
  return PaymentContext(
    // In the smallest unit of the currency: 1298 = EUR 12.98. Currency is ISO 4217, for example 'EUR'.
    AmountOfMoney(totalInMinorUnits, currencyCode),
    countryCode, // ISO 3166-1 alpha-2, for example 'NL'
    isRecurring: false,
  );
}
// [END payment-context]
