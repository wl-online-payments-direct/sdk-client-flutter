import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class OnlinePaymentsSdkPlatform extends PlatformInterface {
  OnlinePaymentsSdkPlatform() : super(token: _token);
  static final Object _token = Object();
  static OnlinePaymentsSdkPlatform _instance = _DefaultOnlinePaymentsSdkPlatform();

  static OnlinePaymentsSdkPlatform get instance => _instance;

  static set instance(OnlinePaymentsSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initializeSession(Map<String, dynamic> sessionDetails) {
    throw UnimplementedError('initializeSession() has not been implemented.');
  }

  Future<dynamic> getBasicPaymentItems(Map<String, dynamic> context) {
    throw UnimplementedError('getBasicPaymentItems() has not been implemented.');
  }

  Future<dynamic> getBasicPaymentProducts(Map<String, dynamic> context) {
    throw UnimplementedError('getBasicPaymentProducts() has not been implemented.');
  }

  Future<dynamic> getPaymentProduct(int id, Map<String, dynamic> context) {
    throw UnimplementedError('getPaymentProduct() has not been implemented.');
  }

  Future<dynamic> getIinDetails(String partialCCNumber, Map<String, dynamic> context) {
    throw UnimplementedError('getIinDetails() has not been implemented.');
  }

  Future<dynamic> getPublicKey() {
    throw UnimplementedError('getPublicKey() has not been implemented.');
  }

  Future<dynamic> getPaymentProductNetworks(int id, Map<String, dynamic> context) {
    throw UnimplementedError('getPaymentProductNetworks() has not been implemented.');
  }

  Future<dynamic> getSurchargeCalculation(Map<String, dynamic> amountOfMoney, Map<String, dynamic> cardOrToken) {
    throw UnimplementedError('getSurchargeCalculation() has not been implemented.');
  }

  Future<dynamic> getCurrencyConversionQuote(Map<String, dynamic> amountOfMoney, Map<String, dynamic> cardOrToken) {
    throw UnimplementedError('getCurrencyConversionQuote() has not been implemented.');
  }

  Future<dynamic> getEncryptor() {
    throw UnimplementedError('getEncryptor() has not been implemented.');
  }
}

class _DefaultOnlinePaymentsSdkPlatform extends OnlinePaymentsSdkPlatform {}
