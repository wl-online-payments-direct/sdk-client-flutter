import 'package:online_payments_sdk/src/web/bindings/js_session_bindings.dart';

JsPaymentContext jsPaymentContextFrom(Map<String, dynamic> map) {
  final amountMap = (map['amountOfMoney'] as Map).cast<String, dynamic>();

  return JsPaymentContext(
    amountOfMoney: JsAmountOfMoney(
      amount: amountMap['amount'] as int,
      currencyCode: amountMap['currencyCode'] as String,
    ),
    countryCode: map['countryCode'] as String,
    isRecurring: map['isRecurring'] as bool?,
    locale: map['locale'] as String?,
  );
}
