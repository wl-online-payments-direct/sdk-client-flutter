import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:online_payments_sdk/src/web/masking/masking_web_handler.dart';
import 'package:online_payments_sdk/src/web/validation/validation_web_handler.dart';

class OnlinePaymentsWeb {
  static void registerWith(Registrar registrar) {
    MaskingWebHandler.register(registrar);
    ValidationWebHandler.register(registrar);
  }
}
