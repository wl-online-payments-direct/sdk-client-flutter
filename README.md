# Online Payments - Flutter SDK

The Online Payments Flutter SDK helps you accept payments in your Flutter app through the
Online Payments platform.

The SDK's main function is to establish a secure channel between your app and our server. This
channel processes security credentials to guarantee safe transit of your customers' data during
the payment process.

**The Online Payments SDK helps you with:**

- handling encryption of payment details
- convenient Dart wrappers for API responses
- user-friendly formatting of payment data, such as card numbers and expiry dates
- validating user input
- determining the card's associated payment provider

## Table of Contents

- [Online Payments - Flutter SDK](#online-payments---flutter-sdk)
  - [Table of Contents](#table-of-contents)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Getting started](#getting-started)
  - [Type definitions](#type-definitions)
    - [OnlinePaymentSdk](#onlinepaymentsdk)
    - [PaymentContext](#paymentcontext)
    - [BasicPaymentProducts](#basicpaymentproducts)
    - [BasicPaymentProduct](#basicpaymentproduct)
    - [AccountOnFile](#accountonfile)
    - [PaymentProduct](#paymentproduct)
    - [PaymentProductField](#paymentproductfield)
    - [PaymentRequest](#paymentrequest)
      - [Tokenize payment request](#tokenize-payment-request)
      - [Set field values to payment request](#set-field-values-to-payment-request)
      - [AccountOnFile with READ\_ONLY fields](#accountonfile-with-read_only-fields)
      - [Validate payment request](#validate-payment-request)
      - [Encrypt payment request](#encrypt-payment-request)
    - [PaymentRequestField](#paymentrequestfield)
      - [Set and retrieve a field value](#set-and-retrieve-a-field-value)
      - [Validate a single field](#validate-a-single-field)
    - [CreditCardTokenRequest](#creditcardtokenrequest)
      - [Encrypt token request](#encrypt-token-request)
    - [IINDetails](#iindetails)
    - [Masking](#masking)
  - [Payment Steps](#payment-steps)
    - [1. Initialize the Flutter SDK for this payment](#1-initialize-the-flutter-sdk-for-this-payment)
    - [2. Retrieve the payment products](#2-retrieve-the-payment-products)
    - [3. Retrieve payment product details](#3-retrieve-payment-product-details)
    - [4. Encrypt payment information](#4-encrypt-payment-information)
    - [5. Response from the Server API call](#5-response-from-the-server-api-call)
  - [Testing](#testing)
    - [Unit tests](#unit-tests)
    - [Integration tests](#integration-tests)

## Requirements

This SDK targets Flutter applications. It requires a backend that can create a Client Session
using the Server API. The session response contains the four values your app needs to initialize
the SDK:

- `clientSessionId`
- `customerId`
- `clientApiUrl`
- `assetUrl`

## Installation

Add the SDK to your app's `pubspec.yaml`, replacing `x.y.z` with the desired version:

```yaml
dependencies:
  online_payments_sdk: ^x.y.z
```

Then run:

```bash
flutter pub get
```

## Getting started

To accept your first payment using the SDK, complete the steps below. Also see
[Payment Steps](#payment-steps) for a more detailed flow.

1. Request your server to create a Client Session using one of the Server SDKs or the Server API
   directly.

2. Initialize the SDK using the session details returned by your server.

   ```dart
   import 'package:online_payments_sdk/online_payments_sdk.dart';

   final sdk = OnlinePaymentSdk(
     SessionData(
       clientSessionId: '47e9dc332ca24273818be2a46072e006',
       customerId: '9991-0d93d6a0e18443bd871c89ec6d38a873',
       clientApiUrl: 'https://clientapi.com',
       assetUrl: 'https://assets.com',
     ),
     configuration: SdkConfiguration(
       appIdentifier: 'MyShopApp/v1.0.0',
     ),
   );
   ```

3. Configure your payment context.

   ```dart
   final paymentContext = PaymentContext(
     AmountOfMoney(1298, 'EUR'),
     'NL',
     isRecurring: false,
   );
   ```

4. Retrieve the available payment products and accounts on file.

   ```dart
   try {
     final basicPaymentProducts = await sdk.getBasicPaymentProducts(paymentContext);
     // Display basicPaymentProducts.paymentProducts and basicPaymentProducts.accountsOnFile
   } on SdkError catch (e) {
     // Handle error while retrieving payment products
   }
   ```

5. Retrieve a detailed `PaymentProduct` for the product selected by your customer.

   ```dart
   try {
     final paymentProduct = await sdk.getPaymentProduct(1, paymentContext);
     // Render paymentProduct.getFields() as a form
   } on SdkError catch (e) {
     // Handle error while retrieving payment product details
   }
   ```

6. Save your customer's input in a `PaymentRequest`.

   ```dart
   final paymentRequest = PaymentRequest(paymentProduct);
   paymentRequest.setValue('cardNumber', '4242424242424242');
   paymentRequest.setValue('cvv', '123');
   paymentRequest.setValue('expiryDate', '1226');
   ```

7. Validate and encrypt the payment request, then send the encrypted data to your server.

   ```dart
   final validationResult = paymentRequest.validate();

   if (!validationResult.isValid) {
     // Show validationResult.errors to your customer
   } else {
     final encryptedRequest = await sdk.encryptPaymentRequest(paymentRequest);
     // Send encryptedRequest.encryptedCustomerInput to your server
   }
   ```

8. From your server, create the payment using the Server API, providing the encrypted data in the
   `encryptedCustomerInput` field.

## Type definitions

### OnlinePaymentSdk

For all interactions with the SDK, an initialized SDK instance is required. In this README, that
instance is referred to as `sdk`. The instance is obtained by constructing `OnlinePaymentSdk` with
session data returned from the Create Client Session Server API call and an optional
`SdkConfiguration` that includes `appIdentifier`, an identifier of your application.

```dart
import 'package:online_payments_sdk/online_payments_sdk.dart';

final sdk = OnlinePaymentSdk(
  SessionData(
    clientSessionId: '47e9dc332ca24273818be2a46072e006',
    customerId: '9991-0d93d6a0e18443bd871c89ec6d38a873',
    clientApiUrl: 'https://clientapi.com',
    assetUrl: 'https://assets.com',
  ),
  configuration: SdkConfiguration(
    appIdentifier: 'MyShopApp/v1.0.0',
  ),
);
```

Available methods on `OnlinePaymentSdk`:

| Method                                            | Description                                                           |
|---------------------------------------------------|-----------------------------------------------------------------------|
| `getBasicPaymentProducts(context)`                | Retrieves available payment products for the given context.           |
| `getPaymentProduct(id, context)`                  | Retrieves full product details including fields and validation rules. |
| `getIinDetails(partialCardNumber, context)`       | Identifies the payment product for a card number prefix.              |
| `getPaymentProductNetworks(productId, context)`   | Retrieves networks for a specific payment product.                    |
| `encryptPaymentRequest(request)`                  | Validates and encrypts a `PaymentRequest`.                            |
| `encryptTokenRequest(request)`                    | Encrypts a `CreditCardTokenRequest`.                                  |
| `getPublicKey()`                                  | Retrieves the server's public encryption key.                         |
| `getSurchargeCalculation(amountOfMoney, card)`    | Retrieves surcharge details for a card.                               |
| `getCurrencyConversionQuote(amountOfMoney, card)` | Retrieves a currency conversion quote.                                |

### PaymentContext

`PaymentContext` describes the payment being made and is required when retrieving payment products.

```dart
final paymentContext = PaymentContext(
  AmountOfMoney(1298, 'EUR'),
  'NL',
  isRecurring: false,
);
```

### BasicPaymentProducts

`getBasicPaymentProducts` returns a `BasicPaymentProducts` object with two properties:

- `paymentProducts` — list of `BasicPaymentProduct` available for the given context.
- `accountsOnFile` — flat list of all `AccountOnFile` objects across all products.

### BasicPaymentProduct

A lightweight product object returned in the product list. Key properties:

- `id` — product ID (`int?`).
- `logo` — URL of the payment product logo.
- `label` — display label.
- `displayOrder` — display ordering hint.
- `accountsOnFile` — stored accounts associated with this product.
- `getAccountOnFile(id)` — retrieves a specific account on file.

### AccountOnFile

Represents saved payment details for a returning customer.

```dart
final accountOnFile = basicPaymentProduct.getAccountOnFile(accountId);
final cardNumber = accountOnFile?.getValue('cardNumber'); // masked stored value
final isCardWritable = accountOnFile?.isWritable('cardNumber');
```

Key methods:

- `getValue(fieldId)` — gets stored (masked) value for a field.
- `getRequiredAttributes()` — attributes the customer must still provide.
- `isWritable(fieldId)` — whether the field can be modified.
- `label` — masked card number suitable for display.

### PaymentProduct

A detailed product object with all fields and validation rules. Retrieved via `getPaymentProduct`.

```dart
final paymentProduct = await sdk.getPaymentProduct(1, paymentContext);

final fields = paymentProduct.getFields();       // all fields
final required = paymentProduct.getRequiredFields(); // only required fields
final cardNumberField = paymentProduct.getField('cardNumber');
```

### PaymentProductField

A field belonging to a `PaymentProduct`, carrying its display hints and validation rules.

```dart
final field = paymentProduct.getField('cardNumber');

field?.getLabel();          // display label
field?.getPlaceholder();    // placeholder text
field?.isRequired();        // whether the field must be filled
field?.shouldObfuscate();   // whether to mask input (e.g., CVV)
field?.applyMask('4242424242424242');    // "4242 4242 4242 4242"
field?.removeMask('4242 4242 4242 4242'); // "4242424242424242"
field?.validate('4242424242424242');    // List<ValidationErrorMessage>
```

### PaymentRequest

`PaymentRequest` holds the customer's payment data and provides validate/encrypt capabilities.

#### Tokenize payment request

To store card details as an account on file, set `tokenize` to `true`:

```dart
final paymentRequest = PaymentRequest(paymentProduct);
paymentRequest.tokenize = true;
```

#### Set field values to payment request

```dart
final paymentRequest = PaymentRequest(paymentProduct);
paymentRequest.setValue('cardNumber', '4242424242424242');
paymentRequest.setValue('cvv', '123');
paymentRequest.setValue('expiryDate', '1226');
paymentRequest.setValue('cardholderName', 'John Doe');
```

#### AccountOnFile with READ_ONLY fields

When a customer selects an account on file, set it on the request. Non-writable field values
already stored in the account on file will be handled automatically.

```dart
paymentRequest.accountOnFile = accountOnFile;
```

Attempting to call `setValue` on a `READ_ONLY` field throws `InvalidArgumentError`.

#### Validate payment request

```dart
final validationResult = paymentRequest.validate();

if (!validationResult.isValid) {
  for (final error in validationResult.errorMessages) {
    // error.paymentProductFieldId — which field failed
    // error.rule                  — which rule was violated
  }
}
```

#### Encrypt payment request

```dart
final encryptedRequest = await sdk.encryptPaymentRequest(paymentRequest);

encryptedRequest.encryptedCustomerInput; // send this to your server
encryptedRequest.encodedClientMetaInfo;
```

### PaymentRequestField

`PaymentRequestField` provides field-level access within a `PaymentRequest`.

#### Set and retrieve a field value

```dart
final field = paymentRequest.getField('cardNumber');

field.setValue('4242424242424242');
field.getValue();         // unmasked: "4242424242424242"
field.getMaskedValue();   // masked:   "4242 4242 4242 4242"
field.clearValue();
```

#### Validate a single field

```dart
final errors = field.validate();
```

### CreditCardTokenRequest

Use `CreditCardTokenRequest` to encrypt a card for tokenization without creating a full payment.

```dart
final tokenRequest = CreditCardTokenRequest()
  ..setPaymentProductId(1)
  ..setCardNumber('4242424242424242')
  ..setSecurityCode('123');
```

#### Encrypt token request

```dart
final encryptedRequest = await sdk.encryptTokenRequest(tokenRequest);
encryptedRequest.encryptedCustomerInput;
```

### IINDetails

The first six digits of a payment card number are known as the Issuer Identification Number (IIN).
Use `sdk.getIinDetails` to determine which payment product is associated with the card being
entered. This is typically called each time the customer has entered at least six digits.

```dart
import 'package:online_payments_sdk/online_payments_sdk.dart';

final paymentContext = PaymentContext(
  AmountOfMoney(1298, 'EUR'),
  'NL',
  isRecurring: false,
);

final iinDetails = await sdk.getIinDetails('456735', paymentContext);

if (iinDetails.status == IinStatus.supported) {
  // iinDetails.paymentProductId — use to load the matching PaymentProduct
}
```

Possible `IinStatus` values:

- `supported` — the IIN is associated with a payment product supported by your account.
- `existingButNotAllowed` — the IIN is recognized, but the product is not allowed for this
  payment or merchant.
- `unsupported` — the IIN is not recognized.
- `notEnoughDigits` — fewer than six digits were provided; the check cannot be performed.
- `unknown` — the status could not be determined.

Some cards are co-branded and can be processed as either a local or an international card. In such
cases, the response includes a `coBrands` list with the available brand options.

```dart
if (iinDetails.coBrands != null && iinDetails.coBrands!.isNotEmpty) {
  // let the customer pick a brand from iinDetails.coBrands
}
```

### Masking

The SDK provides masking helpers on both `PaymentProductField` and `PaymentRequestField` to format
values for display and strip formatting before storing or sending.

```dart
final cardNumberField = paymentProduct.getField('cardNumber');

cardNumberField?.applyMask('4242424242424242');    // "4242 4242 4242 4242"
cardNumberField?.removeMask('4242 4242 4242 4242'); // "4242424242424242"

// Get masked value from a PaymentRequestField for display in your UI
final maskedValue = paymentRequest.getField('cardNumber').getMaskedValue();
```

## Payment Steps

Setting up and completing a payment using the Flutter SDK involves the following steps:

### 1. Initialize the Flutter SDK for this payment

Initialize the SDK using session and customer identifiers, API URLs, and your app identifier. The
session data is obtained by calling the Create Client Session endpoint via your server.

```dart
import 'package:online_payments_sdk/online_payments_sdk.dart';

final sdk = OnlinePaymentSdk(
  SessionData(
    clientSessionId: '47e9dc332ca24273818be2a46072e006',
    customerId: '9991-0d93d6a0e18443bd871c89ec6d38a873',
    clientApiUrl: 'https://clientapi.com',
    assetUrl: 'https://assets.com',
  ),
  configuration: SdkConfiguration(
    appIdentifier: 'MyShopApp/v1.0.0',
  ),
);

final paymentContext = PaymentContext(
  AmountOfMoney(1298, 'EUR'),
  'NL',
  isRecurring: false,
);
```

> A successful Create Session response can be used directly as `SessionData`.

- `clientSessionId` and `customerId` are used for authentication.
- `clientApiUrl` is the base URL for all Client API calls.
- `assetUrl` is used to resolve static assets such as payment product logos.
- `paymentContext` is required when requesting payment product information. Payment products
  available to the customer depend on the amount, currency, and country provided here.

### 2. Retrieve the payment products

Retrieve the payment products and accounts on file available for this payment from the Client API.
Your application can use this data to create the product selection screen.

```dart
final basicPaymentProducts = await sdk.getBasicPaymentProducts(paymentContext);

// basicPaymentProducts.paymentProducts — list of BasicPaymentProduct
// basicPaymentProducts.accountsOnFile  — flat list of AccountOnFile across all products
```

For some payment products, customers can choose to store their payment details as an account on
file for faster checkout. The list returned here includes any stored accounts for the current
customer, which your app can present alongside the available products.

### 3. Retrieve payment product details

Once a product or account on file is selected, retrieve full details — including all fields and
their validation rules — from the Client API. Use this information to render the payment form.

```dart
final paymentProduct = await sdk.getPaymentProduct(1, paymentContext);

final fields = paymentProduct.getFields(); // fields the customer needs to fill in
```

If the customer selected an account on file, values already stored for that account can be
prefilled in the relevant fields. Note that certain fields (such as CVV) will still need to be
entered by the customer even when using an account on file.

### 4. Encrypt payment information

Collect field values from the customer, store them in a `PaymentRequest`, validate, and encrypt.
The encrypted payload is forwarded to your server, which sends it to the Server API.

```dart
final paymentRequest = PaymentRequest(paymentProduct);
paymentRequest.setValue('cardNumber', '4242424242424242');
paymentRequest.setValue('cvv', '123');
paymentRequest.setValue('expiryDate', '1226');

final validationResult = paymentRequest.validate();

if (!validationResult.isValid) {
  // show validationResult.errors to the customer
} else {
  final encryptedRequest = await sdk.encryptPaymentRequest(paymentRequest);
  // send encryptedRequest.encryptedCustomerInput to your server
}
```

The SDK handles requesting the public key from the Client API, performing the encryption, and
BASE-64 encoding the result. You only need to ensure the `PaymentRequest` contains all the
information entered by the customer.

### 5. Response from the Server API call

It is up to your application to handle the Server API response and show the customer the
appropriate screen. In some cases the payment is not yet complete — the customer may need to be
redirected to a third party (such as a bank or PayPal) to authorize it. Refer to the Server API
documentation for the full list of possible response statuses. The Client SDK has no part in the
remainder of the payment flow once the encrypted payload has been submitted.

## Testing

This library contains unit and integration tests.

### Unit tests

Run unit tests with:

```bash
flutter test
```

### Integration tests

Integration tests call the real Client API and require credentials in a JSON file. Copy
`example/integration_test/env.example.json` to `example/integration_test/env.local.json` and
fill in your API credentials:

```bash
cd example
flutter test integration_test/sdk_integration_test.dart --dart-define-from-file=./integration_test/env.local.json
```

The device selector will prompt you to choose a simulator or connected device to run the tests on.
