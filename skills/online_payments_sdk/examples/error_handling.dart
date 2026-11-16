import 'package:flutter/foundation.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

// [START handle-sdk-error]
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
// [END handle-sdk-error]
