# Error handling

All SDK methods that call the Client API return futures. They throw a subclass of `SdkError`
(exported by the SDK). Each error has a `message`.

| Error | When | What to do |
|---|---|---|
| `InvalidArgumentError` | Invalid input: `encryptPaymentRequest` with a request that does not validate (`metadata` is the `ValidationResult`), `setValue` on a field that is not writable for the account on file, `getField` with an id the product does not have, `getIinDetails` with fewer than 6 digits (`metadata` is an `IinDetailsResponse` with `IinStatus.notEnoughDigits`) | Show validation errors; fix the calling code for the other cases |
| `CommunicationError` | No response, a timeout after 30 seconds, or a response that is not JSON. `statusCode` may be set, `cause` holds the underlying exception | Let the customer retry |
| `ResponseError` | The Client API returned an error response. `statusCode` is set; `apiError` has `errorId` and `errors` (each with `errorCode`). Also thrown with `statusCode` 404 when no payment product is available, or for a product the SDK cannot process | `statusCode` 404: not available (the card, payment method or currency conversion offer); do not restart, tell the customer or continue without the offer. Any other status: get new session data, create a new `OnlinePaymentSdk` and restart the checkout |
| `EncryptionError` | Encryption failed, or `encryptTokenRequest` without a payment product id | Restart the checkout |
| `ConfigurationError` | `OnlinePaymentSdk(...)` or `DefaultServiceFactory(...)` with an empty session value or a `clientApiUrl` whose path is not empty or `/client` | Fix the integration |

`getIinDetails` needs different handling: it does not throw for API errors but returns
`IinStatus.unknown`. The API answers HTTP 404 for a card number that matches no payment product of
your account, but `unknown` is also returned for other errors, such as an expired session. Do not
block the form (see [flows.md](flows.md#5-detect-the-card-brand)); an expired session is detected by
the next SDK call, at the latest by `encryptPaymentRequest`.

A card that cannot be converted gets no offer: `getCurrencyConversionQuote` returns a result other
than `ConversionResultType.allowed`, or throws a `ResponseError` with `statusCode` 404 (see
[flows.md](flows.md#currency-conversion)).

<!-- region: handle-sdk-error -->
```dart
enum ErrorAction {
  showValidationErrors, // the customer can fix the input
  retry, // a network problem; the same call can be tried again
  notAvailable, // HTTP 404: the card, payment method or currency conversion offer is not available
  restartCheckout, // get new session data from your backend and create a new OnlinePaymentSdk
  integrationError, // a bug in the integration; fix the code
}

ErrorAction classifySdkError(Object error) {
  switch (error) {
    case InvalidArgumentError():
      // Invalid input, for example encryptPaymentRequest with a request that does not validate
      // (error.metadata is the ValidationResult), or setValue on a READ_ONLY field.
      return ErrorAction.showValidationErrors;
    case CommunicationError():
      // No response, a timeout (30 seconds), or a response that is not JSON. error.statusCode may be set.
      return ErrorAction.retry;
    case ResponseError(:final statusCode, :final apiError):
      // The Client API returned an error, for example because the session is no longer valid.
      // Log only the status code, error id and error codes: never log payment data.
      debugPrint('Client API error $statusCode ${apiError?.errorId} '
          '${apiError?.errors?.map((item) => item.errorCode).join(',')}');
      // HTTP 404: the card, payment method or currency conversion offer is not available. Do not
      // restart: tell the customer, or continue without the offer. Any other status: the session
      // is no longer usable.
      return statusCode == 404 ? ErrorAction.notAvailable : ErrorAction.restartCheckout;
    case EncryptionError():
      return ErrorAction.restartCheckout;
    case ConfigurationError():
      // Empty session values or a clientApiUrl with an unexpected path.
      return ErrorAction.integrationError;
    default:
      throw error;
  }
}
```

Rules:

- Log only `errorId`, error codes and HTTP status codes. Never log `PaymentRequest` values, form
  values, the `metadata` of an `InvalidArgumentError` or the `cause` of a `CommunicationError`. This
  includes crash reporting tools that capture `print` and `debugPrint` output or uncaught errors.
- A failed SDK call never means a payment failed or succeeded. The payment result comes only from
  your backend.
