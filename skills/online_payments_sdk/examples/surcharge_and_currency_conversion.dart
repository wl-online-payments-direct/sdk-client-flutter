import 'package:online_payments_sdk/online_payments_sdk.dart';

import 'merchant_backend.dart';

// [START card-source]
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
// [END card-source]

// [START surcharge-calculation]
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
// [END surcharge-calculation]

// [START currency-conversion]
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
// [END currency-conversion]

// [START currency-conversion-choice]
// Call when the customer actively selects one of the two options. Pass the result to
// submitEncryptedPayment, also when the customer chose your currency. Once the customer chose your
// currency, do not offer the conversion again in this checkout.
CurrencyConversionChoice chooseCurrency(CurrencyConversionOffer offer, {required bool payInCardCurrency}) {
  return CurrencyConversionChoice(dccSessionId: offer.dccSessionId, acceptedByUser: payInCardCurrency);
}
// [END currency-conversion-choice]
