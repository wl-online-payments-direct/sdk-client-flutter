import 'package:online_payments_sdk/src/native/api/native_sdk_interface.dart';
import 'package:online_payments_sdk/src/web/api/web_api_bridge.dart';

class WebSessionAdapter implements NativeSdkInterface {
  final WebApiBridge _bridge;

  WebSessionAdapter(this._bridge);

  @override
  Future<bool> createSession(String createSessionRequest) async {
    return await _bridge.createSession(createSessionRequest);
  }

  @override
  Future<String> getBasicPaymentProducts(String basicPaymentProductRequest) async {
    return await _bridge.getBasicPaymentProducts(basicPaymentProductRequest);
  }

  @override
  Future<String> getPaymentProduct(String paymentProductRequest) async {
    return await _bridge.getPaymentProduct(paymentProductRequest);
  }

  @override
  Future<String> getPublicKey() {
    return _bridge.getPublicKey();
  }

  @override
  Future<String> getIinDetails(String request) {
    return _bridge.getIinDetails(request);
  }

  @override
  Future<String> getPaymentProductNetworks(String request) {
    return _bridge.getPaymentProductNetworks(request);
  }

  @override
  Future<String> getCurrencyConversionQuote(String request) {
    return _bridge.getCurrencyConversionQuote(request);
  }

  @override
  Future<String> getSurchargeCalculation(String request) {
    return _bridge.getSurchargeCalculation(request);
  }

  @override
  Future<String> preparePaymentRequest(String request) {
    return _bridge.preparePaymentRequest(request);
  }
}
