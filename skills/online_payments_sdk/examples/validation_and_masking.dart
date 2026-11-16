import 'package:flutter/services.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

// [START create-payment-request]
PaymentRequest createPaymentRequest(
  PaymentProduct paymentProduct,
  AccountOnFile? accountOnFile, {
  required bool customerWantsToStoreCard,
}) {
  // Ask to store the card only when the product allows it and the customer agreed.
  final tokenize = customerWantsToStoreCard && paymentProduct.allowsTokenization == true;

  return PaymentRequest(paymentProduct: paymentProduct, accountOnFile: accountOnFile, tokenize: tokenize);
}
// [END create-payment-request]

// [START mask-input-formatter]
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
// [END mask-input-formatter]

// [START validate-field]
// Call when a field loses focus. Returns the messages to show under the field.
List<String> fieldErrors(PaymentRequest paymentRequest, String fieldId) {
  return paymentRequest.getField(fieldId).validate().errorMessages.map((error) => error.errorMessage).toList();
}
// [END validate-field]

// [START validate-payment-request]
// Call before encrypting. Returns the error messages per field id; empty when the request is valid.
Map<String, List<String>> validatePaymentRequest(PaymentRequest paymentRequest) {
  final result = paymentRequest.validate();
  final errorsByField = <String, List<String>>{};

  for (final error in result.errorMessages) {
    errorsByField.putIfAbsent(error.paymentProductFieldId, () => []).add(error.errorMessage);
  }

  return errorsByField;
}
// [END validate-payment-request]
