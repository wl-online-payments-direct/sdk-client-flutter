import 'package:online_payments_sdk/online_payments_sdk.dart';

import 'merchant_backend.dart';

// [START encrypt-token-request]
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
// [END encrypt-token-request]
