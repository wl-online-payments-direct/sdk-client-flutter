import 'package:online_payments_sdk/online_payments_sdk.dart';

// [START apple-pay-availability]
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
// [END apple-pay-availability]

// [START wallet-product-data]
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
// [END wallet-product-data]
