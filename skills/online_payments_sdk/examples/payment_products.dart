import 'package:online_payments_sdk/online_payments_sdk.dart';

// [START list-payment-products]
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
// [END list-payment-products]
