import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:online_payments_sdk/src/web/bindings/js_session_bindings.dart';
import 'package:online_payments_sdk/src/web/store/web_session_store.dart';

import '../utils/js_converters.dart';

class ValidationWebHandler {
  static const String _channelName = 'online_payments_validation';

  static void register(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      _channelName,
      const StandardMethodCodec(),
      registrar,
    );

    channel.setMethodCallHandler((MethodCall call) async {
      try {
        switch (call.method) {
          case 'validateValueForPaymentProductField':
            {
              final String requestJson = (call.arguments as Map)['request'] as String;

              return await _validateValueForPaymentProductField(requestJson);
            }
          case 'validatePaymentRequest':
            {
              final String requestJson = (call.arguments as Map)['request'] as String;

              return await _validatePaymentRequest(requestJson);
            }
          default:
            return jsonEncode(<Map<String, String>>[
              {'errorMessage': 'UNKNOWN_METHOD', 'paymentProductFieldId': '*'}
            ]);
        }
      } catch (e) {
        return jsonEncode(<Map<String, String>>[
          {'errorMessage': 'EXCEPTION', 'paymentProductFieldId': '*'}
        ]);
      }
    });
  }

  static Future<String> _validateValueForPaymentProductField(String requestJson) async {
    try {
      final Map<String, dynamic> requestMap = jsonDecode(requestJson) as Map<String, dynamic>;

      final Map<String, dynamic> fieldMap = (requestMap['field'] as Map).cast<String, dynamic>();
      final String fieldId = fieldMap['id'] as String;

      final String value = (requestMap['value'] as String?) ?? '';

      final bool isRequired = (fieldMap['dataRestrictions'] as Map?)?['isRequired'] == true;

      if (isRequired && value.isEmpty) {
        return jsonEncode(<Map<String, String>>[
          {'errorMessage': 'required', 'paymentProductFieldId': fieldId}
        ]);
      }

      final Object? paymentProductObject = requestMap['paymentProduct'];
      if (paymentProductObject is! Map || paymentProductObject['id'] == null) {
        return jsonEncode(<Map<String, String>>[
          {'errorMessage': 'MISSING_PAYMENT_PRODUCT_ID', 'paymentProductFieldId': fieldId}
        ]);
      }

      final int productId = _toInt(paymentProductObject['id']);

      JsPaymentContext? context = _contextFromRequestOrSession(requestMap);
      if (context == null) {
        return jsonEncode(<Map<String, String>>[
          {'errorMessage': 'MISSING_PAYMENT_CONTEXT', 'paymentProductFieldId': fieldId}
        ]);
      }

      final JSObject productJsObject = await WebSessionStore.require.getPaymentProduct(productId, context).toDart;
      final JsPaymentProduct product = productJsObject as JsPaymentProduct;

      final List<JSAny?> productFieldsList = product.paymentProductFields.toDart;
      JsPaymentProductField? target;

      for (final JSAny? f in productFieldsList) {
        final JsPaymentProductField fld = f as JsPaymentProductField;
        if (fld.id == fieldId) {
          target = fld;
          break;
        }
      }

      if (target == null) {
        return jsonEncode(<Map<String, String>>[
          {'errorMessage': 'UNKNOWN_FIELD', 'paymentProductFieldId': fieldId}
        ]);
      }

      final List<String> errorCodes = (target.getErrorCodes(value).toDart as List).cast<String>();

      final List<Map<String, String>> resultList = errorCodes
          .map((c) => <String, String>{
                'errorMessage': c,
                'paymentProductFieldId': fieldId,
              })
          .toList(growable: false);

      final String outJson = jsonEncode(resultList);

      return outJson;
    } catch (e) {
      return jsonEncode(<Map<String, String>>[
        {'errorMessage': 'EXCEPTION', 'paymentProductFieldId': '*'}
      ]);
    }
  }

  static Future<String> _validatePaymentRequest(String requestJson) async {
    try {
      final Map<String, dynamic> requestMap = jsonDecode(requestJson) as Map<String, dynamic>;

      int? productId;

      if (requestMap['paymentProductId'] != null) {
        productId = _toInt(requestMap['paymentProductId']);
      } else if (requestMap['paymentProduct'] is Map && (requestMap['paymentProduct'] as Map)['id'] != null) {
        productId = _toInt((requestMap['paymentProduct'] as Map)['id']);
      }
      if (productId == null) {
        return jsonEncode(<Map<String, String>>[
          {'errorMessage': 'MISSING_PAYMENT_PRODUCT_ID', 'paymentProductFieldId': '*'}
        ]);
      }

      Map<String, dynamic> fieldValuesMap = const <String, dynamic>{};
      if (requestMap['values'] is Map) {
        fieldValuesMap = (requestMap['values'] as Map).cast<String, dynamic>();
      } else if (requestMap['fieldValues'] is Map) {
        fieldValuesMap = (requestMap['fieldValues'] as Map).cast<String, dynamic>();
      }

      JsPaymentContext? context = _contextFromRequestOrSession(requestMap);
      if (context == null) {
        return jsonEncode(<Map<String, String>>[
          {'errorMessage': 'MISSING_PAYMENT_CONTEXT', 'paymentProductFieldId': '*'}
        ]);
      }

      final JSObject productJsObject = await WebSessionStore.require.getPaymentProduct(productId, context).toDart;
      final JsPaymentProduct paymentProduct = productJsObject as JsPaymentProduct;

      final List<Map<String, String>> errorList = <Map<String, String>>[];

      final List<JSAny?> productFieldJsList = paymentProduct.paymentProductFields.toDart;
      for (final JSAny? anyField in productFieldJsList) {
        final JsPaymentProductField field = anyField as JsPaymentProductField;
        final String? currentValue = fieldValuesMap[field.id] as String?;

        final List<String> errorCodes = (field.getErrorCodes(currentValue).toDart as List).cast<String>();

        if (errorCodes.isNotEmpty) {
          for (final String code in errorCodes) {
            errorList.add(<String, String>{
              'errorMessage': code,
              'paymentProductFieldId': field.id,
            });
          }
        }
      }

      final String resultJson = jsonEncode(errorList);

      return resultJson;
    } catch (e) {
      return jsonEncode(<Map<String, String>>[
        {'errorMessage': 'EXCEPTION', 'paymentProductFieldId': '*'}
      ]);
    }
  }

  static JsPaymentContext? _contextFromRequestOrSession(Map<String, dynamic> req) {
    final Object? contextObject = req['paymentContext'];
    if (contextObject is Map) {
      final Map<String, dynamic> contextMap = contextObject.cast<String, dynamic>();
      final JsPaymentContext jsContext = jsPaymentContextFrom(contextMap);
      WebSessionStore.setPaymentContext(jsContext);

      return jsContext;
    }

    return WebSessionStore.context;
  }

  static int _toInt(Object? value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.parse(value);
    }

    throw ArgumentError('Cannot convert to int: $value');
  }
}
