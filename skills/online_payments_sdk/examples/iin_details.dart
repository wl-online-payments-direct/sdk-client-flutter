import 'package:online_payments_sdk/online_payments_sdk.dart';

// [START iin-details]
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
// [END iin-details]
