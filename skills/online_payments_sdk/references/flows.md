# Checkout flows

Every code block below is copied from a file in `../examples/`. The examples call your backend
through the functions in `examples/merchant_backend.dart`; see
[flutter.md](flutter.md#your-backend) for that contract.

The examples are plain functions and classes, not widgets. Call them from your screens: for example
from `initState()` when the checkout screen opens, from a `TextField`'s `inputFormatters` and focus
changes, and from the pay button's `onPressed`.

## 1. Create the SDK

Your backend creates a client session with Create Session and returns its data. Do this for every
checkout, and keep the `OnlinePaymentSdk` instance for the whole checkout.

<!-- region: initialise-sdk -->
```dart
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
```

<!-- region: dispose-sdk -->
```dart
// Call when the checkout ends (paid, cancelled or restarted with new session data), for example
// in the checkout screen's dispose(). It closes the SDK's HTTP client.
void endCheckout(OnlinePaymentSdk sdk) {
  sdk.dispose();
}
```

## 2. Build the payment context

The payment context is passed to most SDK calls. The payment products, surcharge and currency
conversion depend on it, so it must match the order.

<!-- region: payment-context -->
```dart
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
```

## 3. List payment products and stored cards

`getBasicPaymentProducts` returns the payment products available for this context and the
customer's accounts on file (stored cards). Accounts on file are only returned when your backend
passed the customer's tokens to Create Session. The SDK already removes Apple Pay (302) unless you
enabled it (see [Google Pay and Apple Pay](#google-pay-and-apple-pay)) and products it cannot
process. It keeps Google Pay (320), so remove it when your app does not implement Google Pay.
A product's `logo` is a partial URL; build the full URL with the session's `assetUrl`.

<!-- region: list-payment-products -->
```dart
// Google Pay (320) is returned by the SDK, but the payment sheet needs a separate plugin (see the
// wallets section). Leave it out when your app does not implement it.
const googlePayPaymentProductId = 320;

// product.logo is a partial URL: build the full URL with the assetUrl of the session data. To get a
// resized image, append '?size={width}x{height}' (in pixels) to the full URL.
Uri? logoUrl(String assetUrl, String? logo) {
  if (logo == null || logo.isEmpty) {
    return null;
  }
  final base = assetUrl.endsWith('/') ? assetUrl : '$assetUrl/';
  return Uri.parse(base).resolve(logo.startsWith('/') ? logo.substring(1) : logo);
}

class StoredAccount {
  final AccountOnFile accountOnFile; // accountOnFile.label is the display text, for example "4242 **** **** 4242"
  final Uri? logo;

  StoredAccount(this.accountOnFile, {this.logo});
}

class PaymentOptions {
  final List<StoredAccount> storedAccounts;
  final List<BasicPaymentProduct> products; // show each with logoUrl(assetUrl, product.logo)

  PaymentOptions(this.storedAccounts, this.products);
}

Future<PaymentOptions> loadPaymentOptions(
  OnlinePaymentSdk sdk,
  PaymentContext paymentContext,
  String assetUrl, // from the session data
) async {
  // Throws a ResponseError with statusCode 404 when no payment product is available.
  final basicPaymentProducts = await sdk.getBasicPaymentProducts(paymentContext);

  // Accounts on file are the customer's stored cards. They are only returned when your
  // backend passed the customer's tokens to Create Session.
  final storedAccounts = basicPaymentProducts.accountsOnFile
      .map((accountOnFile) => StoredAccount(
            accountOnFile,
            logo: logoUrl(assetUrl, basicPaymentProducts.getBasicPaymentProductById(accountOnFile.paymentProductId)?.logo),
          ))
      .toList();

  // The SDK returns the products sorted by displayOrder.
  final products =
      basicPaymentProducts.products.where((product) => product.id != googlePayPaymentProductId).toList();

  return PaymentOptions(storedAccounts, products);
}
```

## 4. Render the payment form

When the customer selects a product or a stored card, get the full product. It contains the fields
to render. For a stored card, pass the account on file's `paymentProductId`.

<!-- region: get-payment-product -->
```dart
class SelectedProduct {
  final PaymentProduct paymentProduct;
  final AccountOnFile? accountOnFile;

  SelectedProduct(this.paymentProduct, this.accountOnFile);
}

Future<SelectedProduct> loadSelectedProduct(
  OnlinePaymentSdk sdk,
  PaymentContext paymentContext, {
  required int paymentProductId, // for a stored card: accountOnFile.paymentProductId
  String? accountOnFileId,
}) async {
  final paymentProduct = await sdk.getPaymentProduct(paymentProductId, paymentContext);
  final accountOnFile = accountOnFileId != null ? paymentProduct.getAccountOnFile(accountOnFileId) : null;

  return SelectedProduct(paymentProduct, accountOnFile);
}
```

Describe the form from the product's fields, then render one `TextField` per field. Fields of a
stored card that are not writable are shown with their stored value and cannot be edited.

<!-- region: describe-form-fields -->
```dart
// Named FieldSpec, not FormField, to avoid a clash with Flutter's FormField widget.
class FieldSpec {
  final String id;
  final String label;
  final String? placeholder;
  final bool required;
  final bool obfuscate; // render with obscureText: true
  final PaymentProductFieldType type; // for example to choose the keyboardType
  final String? prefilledValue; // the stored value of the account on file, for example a masked card number
  final bool readOnly;

  FieldSpec({
    required this.id,
    required this.label,
    required this.placeholder,
    required this.required,
    required this.obfuscate,
    required this.type,
    required this.prefilledValue,
    required this.readOnly,
  });
}

// Build the form from the fields the API returns. Do not hard-code fields, masks or
// validation rules: they differ per payment product and per merchant configuration.
List<FieldSpec> describeFormFields(PaymentProduct paymentProduct, AccountOnFile? accountOnFile) {
  final fields = [...paymentProduct.fields]..sort((a, b) => a.getDisplayOrder().compareTo(b.getDisplayOrder()));

  return fields
      .map((field) => FieldSpec(
            id: field.id,
            label: field.getLabel(),
            placeholder: field.getPlaceholder(),
            required: field.isRequired(),
            obfuscate: field.shouldObfuscate(),
            type: field.type,
            prefilledValue: accountOnFile?.getValue(field.id),
            readOnly: accountOnFile != null && !accountOnFile.isWritable(field.id),
          ))
      .toList();
}
```

## 5. Detect the card brand

When at least 6 digits have been entered, get the IIN details to find the payment product for the
card. Use the returned `paymentProductId` to show the brand logo and, if it differs from the
selected product, load that product with `getPaymentProduct` and create a new `PaymentRequest` for
it.

<!-- region: iin-details -->
```dart
sealed class CardDetection {
  const CardDetection();
}

class CardNumberTooShort extends CardDetection {
  const CardNumberTooShort();
}

class CardSupported extends CardDetection {
  final int paymentProductId;
  final List<int> coBrandProductIds; // co-branded card: let the customer choose the brand

  const CardSupported(this.paymentProductId, this.coBrandProductIds);
}

class CardNotAllowed extends CardDetection {
  const CardNotAllowed(); // known card, but not accepted for this payment
}

class CardUnknown extends CardDetection {
  const CardUnknown();
}

Future<CardDetection> detectCard(OnlinePaymentSdk sdk, String cardNumberInput, PaymentContext paymentContext) async {
  final digits = cardNumberInput.replaceAll(RegExp(r'\D'), '');

  // getIinDetails throws an InvalidArgumentError below 6 digits, so do not call it earlier.
  if (digits.length < 6) {
    return const CardNumberTooShort();
  }

  // The SDK sends only the first 6 or 8 digits.
  final response = await sdk.getIinDetails(digits, paymentContext);
  final paymentProductId = response.paymentProductId;

  switch (response.status) {
    case IinStatus.supported when paymentProductId != null:
      final coBrandProductIds = response.coBrands
          .where((coBrand) => coBrand.isAllowedInContext)
          .map((coBrand) => coBrand.paymentProductId)
          .toList();
      return CardSupported(paymentProductId, coBrandProductIds);
    case IinStatus.existingButNotAllowed:
      return const CardNotAllowed();
    default:
      // IinStatus.unknown: the SDK returns it, without throwing, whenever the Client API answers
      // with an error. That is the case for a card number that matches no payment product of your
      // account (HTTP 404), and also for an expired session. Do not block the form: an expired
      // session makes the next SDK call (for example encryptPaymentRequest) throw a ResponseError.
      return const CardUnknown();
  }
}
```

The status is `IinStatus.supported`, `IinStatus.existingButNotAllowed` or `IinStatus.unknown` (any
API error, including an unknown card number). `IinStatus.notEnoughDigits` is only the `metadata` of
the `InvalidArgumentError` thrown below 6 digits; `unsupported` is never returned.

## 6. Format and validate input

Create the `PaymentRequest` once the product is loaded.

<!-- region: create-payment-request -->
```dart
PaymentRequest createPaymentRequest(
  PaymentProduct paymentProduct,
  AccountOnFile? accountOnFile, {
  required bool customerWantsToStoreCard,
}) {
  // Ask to store the card only when the product allows it and the customer agreed.
  final tokenize = customerWantsToStoreCard && paymentProduct.allowsTokenization == true;

  return PaymentRequest(paymentProduct: paymentProduct, accountOnFile: accountOnFile, tokenize: tokenize);
}
```

Format each writable field with a `TextInputFormatter`. It stores the value in the `PaymentRequest`
and shows it with the field's mask, if the field has one.

<!-- region: mask-input-formatter -->
```dart
// Add to the TextField of a writable field: inputFormatters: [PaymentFieldFormatter(paymentRequest, field.id)].
// It stores every change in the PaymentRequest. A field with a mask is shown with the mask; a field
// without one (such as the cardholder name) keeps the text as the customer typed it.
// Do not attach it to a READ_ONLY field of the selected account on file: setValue throws an
// InvalidArgumentError for those fields. Render them as read-only text instead.
class PaymentFieldFormatter extends TextInputFormatter {
  final PaymentRequest paymentRequest;
  final String fieldId;

  PaymentFieldFormatter(this.paymentRequest, this.fieldId);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final field = paymentRequest.getField(fieldId);

    // setValue removes the mask before it stores the value, so "4111 1111" is stored as "41111111".
    // An empty string clears the value.
    field.setValue(newValue.text);

    // Without a mask, setValue stores the trimmed text. Writing that back would delete a space as
    // soon as the customer types it, so keep the typed text and the cursor position.
    final mask = paymentRequest.paymentProduct.getField(fieldId)?.displayHints?.mask;
    if (mask == null) return newValue;

    final masked = field.getMaskedValue() ?? '';
    return TextEditingValue(text: masked, selection: TextSelection.collapsed(offset: masked.length));
  }
}
```

<!-- region: validate-field -->
```dart
// Call when a field loses focus. Returns the messages to show under the field.
List<String> fieldErrors(PaymentRequest paymentRequest, String fieldId) {
  return paymentRequest.getField(fieldId).validate().errorMessages.map((error) => error.errorMessage).toList();
}
```

Before encrypting, validate the whole request. With an account on file, the SDK validates the fields
the customer must enter (`mustWrite`) and the fields the customer changed.

<!-- region: validate-payment-request -->
```dart
// Call before encrypting. Returns the error messages per field id; empty when the request is valid.
Map<String, List<String>> validatePaymentRequest(PaymentRequest paymentRequest) {
  final result = paymentRequest.validate();
  final errorsByField = <String, List<String>>{};

  for (final error in result.errorMessages) {
    errorsByField.putIfAbsent(error.paymentProductFieldId, () => []).add(error.errorMessage);
  }

  return errorsByField;
}
```

## 7. Surcharge and currency conversion (optional)

Only when your merchant account has surcharging or dynamic currency conversion enabled. Call these
once the card product is known, and show the result before the customer pays.

<!-- region: card-source -->
```dart
// The card for a surcharge or currency conversion request. For a card being entered: the first 8
// digits (at least 6) and the product id from the IIN details. Never send the complete card number:
// these requests are not encrypted, and the brand and issuer are known from the first digits.
CardSource cardSourceForEnteredCard(String digits, int paymentProductId) {
  final partialCardNumber = digits.length > 8 ? digits.substring(0, 8) : digits;
  return CardSourceWithCard(Card(partialCardNumber, paymentProductId: paymentProductId));
}

// For a stored card: the account on file id is the token.
CardSource cardSourceForAccountOnFile(AccountOnFile accountOnFile) {
  return CardSourceWithToken(accountOnFile.id);
}
```

### Surcharge

The payment context keeps the net amount (without surcharge); the platform adds the surcharge when
your backend creates the payment with `order.surchargeSpecificInput.mode` set to `on-behalf-of`.
Show the surcharge and the total before the customer pays.

<!-- region: surcharge-calculation -->
```dart
class SurchargeOffer {
  final AmountOfMoney surchargeAmount;
  final AmountOfMoney totalAmount;

  SurchargeOffer(this.surchargeAmount, this.totalAmount);
}

// Call once the card is known. Returns null when no surcharge applies.
Future<SurchargeOffer?> getSurcharge(
  OnlinePaymentSdk sdk,
  PaymentContext paymentContext, // keeps the net amount: the platform adds the surcharge
  CardSource cardSource,
) async {
  final response = await sdk.getSurchargeCalculation(paymentContext.amountOfMoney, cardSource);
  final surcharge = response.surcharges.firstOrNull;

  // Check the result before reading the amounts.
  if (surcharge == null || surcharge.result == SurchargeResult.noSurcharge) {
    return null;
  }

  // Show both amounts to the customer before they pay.
  return SurchargeOffer(surcharge.surchargeAmount, surcharge.totalAmount);
}
```

### Currency conversion

Dynamic currency conversion (eDCC, Visa and Mastercard only) lets the customer pay in their card's
currency. The card schemes' rules apply to how you show the offer:

- Show both amounts as two equal options: same size, colour and font. Include your currency, the
  card's currency, the exchange rate, the mark-up and `proposal.disclaimerDisplay`.
- Preselect neither option. Do not use a yes/no or accept/decline question, a switch or a checkbox:
  the customer must actively choose one amount.
- If the customer chooses your currency, continue in your currency and do not offer the conversion
  again in this checkout.

<!-- region: currency-conversion -->
```dart
class CurrencyConversionOffer {
  final String dccSessionId;
  final DccProposal proposal;

  CurrencyConversionOffer(this.dccSessionId, this.proposal);
}

// Call once the card is known. Returns null when there is no offer: then pay in your currency and
// send no currency conversion data.
Future<CurrencyConversionOffer?> getCurrencyConversionOffer(
  OnlinePaymentSdk sdk,
  AmountOfMoney amountToPay, // the order amount, or the surcharge's totalAmount when a surcharge applies
  CardSource cardSource,
) async {
  final CurrencyConversionResponse response;
  try {
    response = await sdk.getCurrencyConversionQuote(amountToPay, cardSource);
  } on ResponseError catch (error) {
    if (error.statusCode == 404) {
      return null; // the card cannot be converted: no offer
    }
    rethrow;
  }

  // InvalidCard, InvalidMerchant, NoRate and NotAvailable mean: no offer. dccSessionId is then empty
  // and the response has no proposal: check the result before reading response.proposal.
  if (response.result.result != ConversionResultType.allowed) {
    return null;
  }

  // Show two options with the same size, colour and font: proposal.baseAmount (your currency) and
  // proposal.targetAmount (the card's currency), with proposal.rate.exchangeRate, proposal.rate.markUpRate
  // (a percentage: 3.12 means 3.12 %) and proposal.disclaimerDisplay. Preselect neither option and do
  // not ask a yes/no question: the customer must actively choose one.
  return CurrencyConversionOffer(response.dccSessionId, response.proposal);
}
```

When the customer has chosen, send the choice with the payment. Your backend passes it to Create
Payment as `cardPaymentMethodSpecificInput.currencyConversion`. Both `dccSessionId` and
`acceptedByUser` are required, also when the customer chose your currency (`acceptedByUser: false`).

<!-- region: currency-conversion-choice -->
```dart
// Call when the customer actively selects one of the two options. Pass the result to
// submitEncryptedPayment, also when the customer chose your currency. Once the customer chose your
// currency, do not offer the conversion again in this checkout.
CurrencyConversionChoice chooseCurrency(CurrencyConversionOffer offer, {required bool payInCardCurrency}) {
  return CurrencyConversionChoice(dccSessionId: offer.dccSessionId, acceptedByUser: payInCardCurrency);
}
```

When both surcharging and currency conversion apply, calculate the surcharge first and request the
currency conversion quote for the surcharge's `totalAmount` (net amount plus surcharge), as the Client
API reference prescribes. Without a surcharge, request it for the order amount. The payment context
keeps the net amount in both cases.

## 8. Encrypt and send to your backend

`encryptPaymentRequest` validates the request again and throws an `InvalidArgumentError` if it is
not valid. The result has two parts: `encryptedCustomerInput` and `encodedClientMetaInfo`. Send both
to your backend; it passes them to Create Payment.

<!-- region: encrypt-payment-request -->
```dart
sealed class PaymentSubmission {
  const PaymentSubmission();
}

class PaymentInputInvalid extends PaymentSubmission {
  final Map<String, List<String>> errorsByField; // show these next to the fields; nothing was sent

  const PaymentInputInvalid(this.errorsByField);
}

class PaymentSubmitted extends PaymentSubmission {
  final MerchantPaymentResponse result;

  const PaymentSubmitted(this.result);
}

Future<PaymentSubmission> payWithEncryptedRequest(
  OnlinePaymentSdk sdk,
  PaymentRequest paymentRequest, {
  required String orderId,
  CurrencyConversionChoice? currencyConversion, // the customer's choice, when a conversion offer was shown
}) async {
  final errorsByField = validatePaymentRequest(paymentRequest);
  if (errorsByField.isNotEmpty) {
    return PaymentInputInvalid(errorsByField); // do not encrypt
  }

  // The only way card data leaves the device: encrypted by the SDK.
  // Never send, log or store the raw field values.
  final encryptedRequest = await sdk.encryptPaymentRequest(paymentRequest);

  // Your backend passes encryptedCustomerInput to Create Payment and decides the outcome.
  final result = await submitEncryptedPayment(orderId, encryptedRequest, currencyConversion: currencyConversion);

  return PaymentSubmitted(result);
}
```

## 9. Session expired or other API errors

When an SDK call throws a `ResponseError`, the session is no longer usable, unless the status code is
404 (the card, payment method or currency conversion offer is not available: do not restart). Get new
session data, create a new `OnlinePaymentSdk` (call `dispose()` on the old one), load the payment
product again and create a new `PaymentRequest`. See [errors.md](errors.md). Whether the customer's
input is kept after a new session is your decision; this skill does not prescribe it.

## 10. Handle the result

Your backend returns what Create Payment returned. When the payment needs a redirect (for example
3-D Secure), the backend returns the redirect URL from that response. The app opens it in the
browser and records the order id, so it can ask for the status when the customer comes back.

<!-- region: pending-payment-store -->
```dart
// Remembers the order that waits for its result while the customer is on the 3-D Secure page.
// Persist it (for example with shared_preferences), because the system can stop the app meanwhile.
// Store only the order id: never card data or session data.
abstract class PendingPaymentStore {
  Future<String?> readOrderId();
  Future<void> saveOrderId(String orderId);
  Future<void> clear();
}
```

<!-- region: handle-payment-result -->
```dart
Future<void> handlePaymentResult(
  MerchantPaymentResponse result, {
  required String orderId,
  required PendingPaymentStore pendingPayments,
}) async {
  final redirectUrl = result.redirectUrl;
  if (redirectUrl != null) {
    // For example 3-D Secure or a third-party payment page. Open the URL exactly as received:
    // do not build or change it. Your backend sets the payment's returnUrl to a deep link of
    // this app, so the customer comes back to the app afterwards.
    await pendingPayments.saveOrderId(orderId);
    final opened = await launchUrl(Uri.parse(redirectUrl), mode: LaunchMode.externalApplication);
    if (!opened) {
      await pendingPayments.clear();
      showStatusUnknown(); // the payment exists; let the customer check the order later
    }
    return;
  }

  // The status comes from your backend. The app never decides that a payment succeeded.
  showPaymentOutcome(result.status);
}
```

After the redirect, the customer comes back through your return URL (a deep link, see
[flutter.md](flutter.md#platform-setup)). Listen for it while the app runs. Do this at the root of
the app, not in the checkout screen, and keep the order id in persistent storage, not only in memory:

<!-- region: handle-return-deep-link -->
```dart
// Start once at the root of the app (in main() or the initState() of your root widget), not in the
// checkout screen: the customer can come back while another screen is shown, or the app can start
// on another screen. Cancel the subscription when the app closes. returnUrlPrefix is the start of the
// returnUrl your backend sets, for example 'myshop://payment-return'.
StreamSubscription<Uri> listenForPaymentReturn(
  AppLinks appLinks,
  String returnUrlPrefix,
  PendingPaymentStore pendingPayments,
) {
  return appLinks.uriLinkStream.listen((uri) {
    unawaited(_onReturnLink(uri, returnUrlPrefix, pendingPayments));
  });
}

Future<void> _onReturnLink(Uri uri, String returnUrlPrefix, PendingPaymentStore pendingPayments) async {
  if (!uri.toString().startsWith(returnUrlPrefix)) {
    return;
  }

  // Act only when a payment waits for its result. The same link can be delivered more than once,
  // for example as the initial link and as a stream event.
  final orderId = await pendingPayments.readOrderId();
  if (orderId == null) {
    return;
  }
  await pendingPayments.clear();

  // Do not read the outcome from the URL: ask your backend for the status.
  try {
    final result = await fetchPaymentStatus(orderId);
    showPaymentOutcome(result.status);
  } catch (_) {
    showStatusUnknown(); // the outcome is unknown, not failed: let the customer check the order later
  }
}
```

The deep link can also start the app, when the system stopped it while the customer was on the 3-D
Secure page. Check the start link once, at start-up, also at the root of the app. Checking only when
the app returns to the foreground (`AppLifecycleState.resumed`) does not cover this case:

<!-- region: handle-return-cold-start -->
```dart
// If the system stopped the app while the customer was on the 3-D Secure page, the deep link
// starts the app again. Check the link that started the app once, at start-up, at the root of the
// app (next to listenForPaymentReturn), not in the checkout screen.
// _onReturnLink only acts when a payment is waiting for its result, so an old start link is ignored.
Future<void> checkPaymentReturnOnStart(
  AppLinks appLinks,
  String returnUrlPrefix,
  PendingPaymentStore pendingPayments,
) async {
  final initialLink = await appLinks.getInitialLink();
  if (initialLink != null) {
    await _onReturnLink(initialLink, returnUrlPrefix, pendingPayments);
  }
}
```

## Tokenization without a payment

To store a card without paying, use `CreditCardTokenRequest`. It applies no validation of its own,
so validate the values with the card product's fields first. Load the card product with
`getIinDetails` and `getPaymentProduct` as in a payment. There is no order amount, so create the
`PaymentContext` with an amount of 1, the smallest unit of the currency (for example 1 cent for
EUR). Do not use 0: the Client API answers an amount of 0 with an error.

<!-- region: encrypt-token-request -->
```dart
const cardFieldIds = ['cardNumber', 'cardholderName', 'expiryDate', 'cvv'];

sealed class StoreCardResult {
  const StoreCardResult();
}

class StoreCardInvalid extends StoreCardResult {
  final Map<String, List<String>> errorsByField; // show these next to the fields; nothing was sent

  const StoreCardInvalid(this.errorsByField);
}

class CardStored extends StoreCardResult {
  final String token;

  const CardStored(this.token);
}

Future<StoreCardResult> storeCard(
  OnlinePaymentSdk sdk,
  PaymentProduct cardProduct, // from sdk.getPaymentProduct for the detected card product
  Map<String, String> form, // field id -> the value as shown in the input, with or without mask
) async {
  // Remove the masks first ("12/26" becomes "1226"): the validation rules and the token request
  // expect values without formatting.
  final values = <String, String>{
    for (final fieldId in cardFieldIds)
      fieldId: cardProduct.getField(fieldId)?.removeMask(form[fieldId] ?? '') ?? (form[fieldId] ?? ''),
  };

  // CreditCardTokenRequest applies no validation, so validate with the product's fields first.
  final errorsByField = <String, List<String>>{};
  for (final fieldId in cardFieldIds) {
    final errors = cardProduct.getField(fieldId)?.validate(values[fieldId]) ?? const [];
    if (errors.isNotEmpty) {
      errorsByField[fieldId] = errors.map((error) => error.errorMessage).toList();
    }
  }
  if (errorsByField.isNotEmpty) {
    return StoreCardInvalid(errorsByField);
  }

  final tokenRequest = CreditCardTokenRequest()
    ..setCardNumber(values['cardNumber'])
    ..setCardholderName(values['cardholderName'])
    ..setExpiryDate(values['expiryDate'])
    ..setSecurityCode(values['cvv'])
    ..setPaymentProductId(cardProduct.id); // required: encryption fails with an EncryptionError without it

  final encryptedRequest = await sdk.encryptTokenRequest(tokenRequest);

  // Your backend creates the token with the encrypted data.
  return CardStored(await submitEncryptedToken(encryptedRequest));
}
```

## Google Pay and Apple Pay

The SDK has no Google Pay or Apple Pay payment flow: it does not show the payment sheet and does not
encrypt the wallet token. It only:

- removes Apple Pay (302) from the payment products, unless you tell it that Apple Pay can be used on
  this device;
- returns the networks (and for Google Pay the gateway) for the payment sheet configuration.

<!-- region: apple-pay-availability -->
```dart
// The SDK removes Apple Pay (302) from the payment products unless you tell it that Apple Pay can
// be used on this device. The SDK cannot check this itself: use your Apple Pay plugin's check.
class DeviceApplePay implements ApplePay {
  final Future<bool> Function() _canUseApplePay;

  DeviceApplePay(this._canUseApplePay);

  @override
  Future<bool> isApplePayAvailable() => _canUseApplePay();
}

OnlinePaymentSdk createSdkWithApplePay(SessionData sessionData, Future<bool> Function() canUseApplePay) {
  return OnlinePaymentSdk(
    sessionData,
    // When you pass a factory, OnlinePaymentSdk ignores its own configuration parameter: pass the
    // configuration to the factory.
    factory: DefaultServiceFactory(
      sessionData,
      configuration: const SdkConfiguration(appIdentifier: 'MyShopApp/1.0.0'),
      applePay: DeviceApplePay(canUseApplePay),
    ),
  );
}
```

<!-- region: wallet-product-data -->
```dart
// The data the SDK returns for the wallet payment sheets. Use it in your Google Pay or Apple Pay
// plugin's payment configuration, together with the values from the Worldline wallet documentation.
class WalletConfiguration {
  final int paymentProductId; // 320 for Google Pay, 302 for Apple Pay
  final List<String> networks; // the card networks to allow in the payment sheet
  final String? gateway; // Google Pay only: the gateway for the tokenization specification

  WalletConfiguration(this.paymentProductId, this.networks, {this.gateway});
}

WalletConfiguration? walletConfiguration(BasicPaymentProduct product) {
  final googlePay = product.paymentProduct320SpecificData;
  if (googlePay != null) {
    return WalletConfiguration(320, googlePay.networks, gateway: googlePay.gateway);
  }
  final applePay = product.paymentProduct302SpecificData;
  if (applePay != null) {
    return WalletConfiguration(302, applePay.networks);
  }
  return null;
}
```

To show the payment sheet, use a separate wallet plugin. Send the token it returns to your backend,
which creates the payment with it (`mobilePaymentMethodSpecificInput`). Follow the Worldline Direct
documentation for Google Pay and Apple Pay for the merchant identifiers and the backend call. The
mandatory rules still apply: the amount in the payment sheet is the real order amount, and the app
shows the status your backend returns. A wallet payment can also return a redirect URL (for example
for 3-D Secure): handle it exactly as in [10. Handle the result](#10-handle-the-result), with the
order id stored before the redirect and the return deep link handled at the root of the app.
