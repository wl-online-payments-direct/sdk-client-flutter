@JS()
library;

import 'dart:js_interop';

@JS('onlinepaymentssdk.Session')
@staticInterop
class JsSession {
  external factory JsSession(JsSessionDetails details);
}

extension JsSessionExtension on JsSession {
  external JSPromise<JSObject> getPublicKey();

  external JSPromise<JSObject> getPaymentProduct(int id, JsPaymentContext context);

  external JSPromise<JSObject> getBasicPaymentProducts(JsPaymentContext context);

  external JSPromise<JSObject> getIinDetails(String cardNumber, JsPaymentContext context);

  external JSPromise<JSObject> getPaymentProductNetworks(int id, JsPaymentContext context);

  external JSPromise<JSObject> getCurrencyConversionQuote(JsAmountOfMoney amount, JSAny cardOrToken);

  external JSPromise<JSObject> getSurchargeCalculation(JsAmountOfMoney amount, JSAny cardOrToken);
}

@JS()
@anonymous
@staticInterop
class JsSessionDetails {
  external factory JsSessionDetails({
    String clientSessionId,
    String customerId,
    String clientApiUrl,
    String assetUrl,
  });
}

extension JsSessionDetailsProps on JsSessionDetails {
  external String get clientSessionId;

  external String get customerId;

  external String get clientApiUrl;

  external String get assetUrl;
}

@JS()
@anonymous
@staticInterop
class JsAmountOfMoney {
  external factory JsAmountOfMoney({
    int amount,
    String currencyCode,
  });
}

extension JsAmountOfMoneyProps on JsAmountOfMoney {
  external int get amount;

  external String get currencyCode;
}

@JS()
@anonymous
@staticInterop
class JsPaymentContext {
  external factory JsPaymentContext({
    JsAmountOfMoney amountOfMoney,
    String countryCode,
    bool? isRecurring,
    String? locale,
  });
}

extension JsPaymentContextProps on JsPaymentContext {
  external JsAmountOfMoney get amountOfMoney;

  external String get countryCode;

  external bool? get isRecurring;

  external String? get locale;
}

@JS('onlinepaymentssdk.PaymentProduct')
@staticInterop
class JsPaymentProduct {
  external factory JsPaymentProduct(JSAny json);
}

extension JsPaymentProductDetails on JsPaymentProduct {
  external JSArray get paymentProductFields;
}

@JS('onlinepaymentssdk.PaymentProductField')
@staticInterop
class JsPaymentProductField {
  external factory JsPaymentProductField(JSAny json);
}

extension JsPaymentProductFieldDetails on JsPaymentProductField {
  external String get id;

  external JSArray getErrorCodes(String? value);

  external bool isValid(String value);
}

@JS('onlinepaymentssdk.PaymentRequest')
@staticInterop
class JsPaymentRequest {
  external factory JsPaymentRequest();
}

extension JsPaymentRequestDetails on JsPaymentRequest {
  external void setPaymentProduct(JsPaymentProduct product);

  external void setValue(String fieldId, String? value);

  external void setTokenize(bool tokenize);

  external bool isValid();

  external JSArray getErrorMessageIds();
}

@JS('onlinepaymentssdk.Encryptor')
@staticInterop
class JsEncryptor {}

extension JsEncryptorDetails on JsEncryptor {
  external JSPromise<JSAny?> encrypt(JsPaymentRequest request);
}

extension JsSessionEncryptor on JsSession {
  external JsEncryptor getEncryptor();
}
