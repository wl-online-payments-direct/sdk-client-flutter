---
name: online_payments_sdk
description: Build in-app card checkouts with the Online Payments Flutter client SDK (pub package online_payments_sdk). Use when Dart code initialises OnlinePaymentSdk from client session data, lists payment products or stored cards (accounts on file), renders payment product fields in TextFields, detects the card brand (IIN details), validates or masks card input, encrypts a payment or token request, handles the 3-D Secure redirect and the return to the app through a deep link, shows a surcharge or currency conversion offer, or prepares Google Pay or Apple Pay products.
---

# Online Payments Flutter client SDK

This skill covers the app side of an Online Payments card checkout built with the Flutter package
`online_payments_sdk`. The SDK runs in the app (Android, iOS and web): it reads payment products
from the Client API, validates and formats customer input, and encrypts it. The encrypted result is
sent to your own backend, which creates the payment.

## How to use this skill

- Use the code in the reference files. Do not write calls to this SDK from memory: copy the
  example code and adapt names and UI.
- Read [references/flows.md](references/flows.md) for the checkout steps and
  [references/errors.md](references/errors.md) before writing error handling.
- Read [references/flutter.md](references/flutter.md) for installation, Android and iOS setup,
  imports and the list of SDK methods.
- The examples in `examples/` are complete Dart files that are analysed against the SDK on every
  SDK build.
- For classes and fields not shown here, read the SDK's [README](../../README.md) or the source in
  the installed package (`lib/src/`). For API fields, see the
  [Client API reference](https://docs.direct.worldline-solutions.com/en/api-reference).

## Mandatory rules

Follow all of these in every integration:

1. Never put the API key or API secret in the app. Create the SDK only with the session data your
   backend returns: `clientSessionId`, `customerId`, `clientApiUrl` and `assetUrl`.
2. Use new session data for every checkout. Do not reuse or cache session data across customers or
   payments. When a call throws a `ResponseError` with status code 404, the card, payment method or
   currency conversion offer is not available: do not restart; tell the customer, or continue
   without the offer. After any other `ResponseError`, get new session data and create a new
   `OnlinePaymentSdk`.
3. Card data only leaves the device through `sdk.encryptPaymentRequest` (or
   `sdk.encryptTokenRequest` for tokenization). Never send raw card data to your backend, never log
   it and never store it (no shared_preferences, no files, no state restoration). Do not call
   `sdk.getPublicKey` to encrypt data yourself.
4. Build the payment form from the fields returned by `sdk.getPaymentProduct`: labels, masks,
   placeholders, obfuscation and validation rules. Do not hard-code fields or validation rules for a
   payment product.
5. Validate the `PaymentRequest` with `paymentRequest.validate()` before encrypting it, and show the
   errors to the customer next to their fields.
6. The amount, currency and country in the `PaymentContext` must be the real values of the order
   being paid.
7. The app never decides the payment outcome. After sending the encrypted data, show the result your
   backend returns. When the backend returns a redirect URL, open that URL exactly as received; do
   not build or change it. When the customer comes back to the app, ask your backend for the status:
   store the order id before opening the URL, and handle the return deep link at the root of the app,
   also when the link starts the app (see `examples/redirect_handling.dart`). This applies to every
   payment that can return a redirect URL, including wallet payments.
8. This SDK has no logging option. Do not log form values, `PaymentRequest` values or SDK request
   bodies with `print`, `debugPrint`, crash reporting or analytics. Log only error ids and codes.

## Checkout steps

1. Get new session data from your backend and create `OnlinePaymentSdk(sessionData, ...)`.
2. Build the `PaymentContext` from the order.
3. `sdk.getBasicPaymentProducts()`: show payment products and stored cards.
4. `sdk.getPaymentProduct()`: render the form from its fields.
5. While the customer types: `sdk.getIinDetails()` for the card brand, `setValue()` and
   `getMaskedValue()` for formatting (a `TextInputFormatter`), `validate()` per field.
6. Optional: `sdk.getSurchargeCalculation()` or `sdk.getCurrencyConversionQuote()`. A currency
   conversion offer must not have a preselected option; the customer actively chooses.
7. `paymentRequest.validate()`, then `sdk.encryptPaymentRequest()`.
8. Send `encryptedCustomerInput` and `encodedClientMetaInfo` to your backend, plus `dccSessionId`
   and `acceptedByUser` when a currency conversion offer was shown.
9. Handle the backend's response: open the redirect URL or show the result. When the customer
   returns through the deep link (also when it starts the app), ask your backend for the status.
10. Call `sdk.dispose()` when the checkout ends.

Card tokenization without a payment, and what the SDK does for Google Pay and Apple Pay, are
described in [references/flows.md](references/flows.md).
