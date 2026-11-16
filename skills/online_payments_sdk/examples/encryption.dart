import 'package:online_payments_sdk/online_payments_sdk.dart';

import 'merchant_backend.dart';
import 'validation_and_masking.dart';

// [START encrypt-payment-request]
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
// [END encrypt-payment-request]
