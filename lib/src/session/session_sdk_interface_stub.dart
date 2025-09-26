import 'package:online_payments_sdk/src/native/api/native_sdk_interface.dart';

class _UnsupportedSdkBridge extends NativeSdkInterface {
  @override
  Future<bool> createSession(String createSessionRequest) {
    throw UnsupportedError('createSession is not supported on this platform');
  }

  @override
  Future<String> getBasicPaymentProducts(String request) {
    throw UnsupportedError('getBasicPaymentProducts is not supported on this platform.');
  }

  @override
  Future<String> getCurrencyConversionQuote(String request) {
    throw UnsupportedError('getCurrencyConversionQuote is not supported on this platform.');
  }

  @override
  Future<String> getIinDetails(String request) {
    throw UnsupportedError('getIinDetails is not supported on this platform.');
  }

  @override
  Future<String> getPaymentProduct(String request) {
    throw UnsupportedError('getPaymentProduct is not supported on this platform.');
  }

  @override
  Future<String> getPaymentProductNetworks(String request) {
    throw UnsupportedError('getPaymentProductNetworks is not supported on this platform.');
  }

  @override
  Future<String> getPublicKey() {
    throw UnsupportedError('getPublicKey is not supported on this platform.');
  }

  @override
  Future<String> getSurchargeCalculation(String request) {
    throw UnsupportedError('getSurchargeCalculation is not supported on this platform.');
  }

  @override
  Future<String> preparePaymentRequest(String request) {
    throw UnsupportedError('preparePaymentRequest is not supported on this platform.');
  }
}

NativeSdkInterface createPlatformSdkBridge() => _UnsupportedSdkBridge();
