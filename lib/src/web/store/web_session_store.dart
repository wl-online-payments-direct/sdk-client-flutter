import 'package:online_payments_sdk/src/web/bindings/js_session_bindings.dart';

final class WebSessionStore {
  static JsSession? jsSession;
  static JsPaymentContext? context;

  static void set(JsSession session) => jsSession = session;

  static JsSession get require => jsSession!;

  static void setPaymentContext(JsPaymentContext paymentContext) {
    context = paymentContext;
  }
}
