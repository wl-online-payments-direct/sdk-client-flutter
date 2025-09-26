import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js_util.dart' as js_util;
import 'package:online_payments_sdk/src/web/bindings/js_masking_bindings.dart';
import 'package:online_payments_sdk/src/web/bindings/js_session_bindings.dart';
import 'package:online_payments_sdk/src/web/store/web_session_store.dart';
import 'package:online_payments_sdk/src/web/utils/js_converters.dart';

class MaskingWebHandler {
  static void register(Registrar registrar) {
    final channel = MethodChannel(
      'online_payments_masking',
      const StandardMethodCodec(),
      registrar,
    );
    final instance = _MaskingJsDelegate();
    channel.setMethodCallHandler(instance.handle);
  }
}

class _MaskingJsDelegate {
  Future<dynamic> handle(MethodCall call) async {
    switch (call.method) {
      case 'applyMaskForPaymentProductField':
        return applyMaskForPaymentProductField(call);
      case 'removeMaskForPaymentProductField':
        return removeMaskForPaymentProductField(call);
      case 'maskedValueForPaymentRequest':
        return maskedValueForPaymentRequest(call);
      case 'unmaskedValueForPaymentRequest':
        return unmaskedValueForPaymentRequest(call);
      case 'allMaskedValuesForPaymentRequest':
        return allMaskedValuesForPaymentRequest(call);
      case 'allUnmaskedValuesForPaymentRequest':
        return allUnmaskedValuesForPaymentRequest(call);
      case 'maskedValueForAccountOnFile':
        return maskedValueForAccountOnFile(call);
      default:
        throw PlatformException(code: 'Unimplemented', message: call.method);
    }
  }

  Future<String> applyMaskForPaymentProductField(MethodCall call) async {
    final Map<String, dynamic> argumentsMap = _asMap(call.arguments, 'applyMaskForPaymentProductField.args');
    final Map<String, dynamic> requestMap = _decodeRequest(argumentsMap, 'applyMaskForPaymentProductField.request');
    final Map<String, dynamic> fieldMap = _asMap(requestMap['field'], 'applyMaskForPaymentProductField.field');

    final String fieldValue = (requestMap['value'] ?? '').toString();
    final String mask = _maskFromField(fieldMap);

    final util = JsMaskingUtil();
    final JsMaskedString masked = util.applyMask(mask, fieldValue);

    return masked.formattedValue;
  }

  Future<String> removeMaskForPaymentProductField(MethodCall call) async {
    final Map<String, dynamic> argumentsMap = _asMap(call.arguments, 'removeMaskForPaymentProductField.args');
    final Map<String, dynamic> requestMap = _decodeRequest(argumentsMap, 'removeMaskForPaymentProductField.request');
    final Map<String, dynamic> fieldMap = _asMap(requestMap['field'], 'removeMaskForPaymentProductField.field');

    final String fieldValue = (requestMap['value'] ?? '').toString();
    final String mask = _maskFromField(fieldMap);

    final util = JsMaskingUtil();

    return util.removeMask(mask, fieldValue);
  }

  Future<String> maskedValueForPaymentRequest(MethodCall call) async {
    final Map<String, dynamic> argumentsMap = _asMap(call.arguments, 'maskedValueForPaymentRequest.args');
    final Map<String, dynamic> requestMap = _decodeRequest(argumentsMap, 'maskedValueForPaymentRequest.request');
    final String fieldId = (requestMap['fieldId'] ?? '').toString();

    final JsPaymentRequest jsPaymentRequest = await _buildJsPaymentRequest(requestMap);

    final Object maskedValuesJs = js_util.callMethod(jsPaymentRequest, 'getMaskedValues', const []);
    final Map<String, dynamic> maskedValuesMap = (js_util.dartify(maskedValuesJs) as Map).cast<String, dynamic>();

    return (maskedValuesMap[fieldId] as String?) ?? '';
  }

  Future<String> unmaskedValueForPaymentRequest(MethodCall call) async {
    final Map<String, dynamic> argumentsMap = _asMap(call.arguments, 'unmaskedValueForPaymentRequest.args');
    final Map<String, dynamic> requestMap = _decodeRequest(argumentsMap, 'unmaskedValueForPaymentRequest.request');
    final String fieldId = (requestMap['fieldId'] ?? '').toString();

    final JsPaymentRequest jsPaymentRequest = await _buildJsPaymentRequest(requestMap);

    final Object unmaskedValuesJs = js_util.callMethod(jsPaymentRequest, 'getUnmaskedValues', const []);
    final Map<String, dynamic> unmaskedValuesMap = (js_util.dartify(unmaskedValuesJs) as Map).cast<String, dynamic>();

    return (unmaskedValuesMap[fieldId] as String?) ?? '';
  }

  Future<String> allMaskedValuesForPaymentRequest(MethodCall call) async {
    final Map<String, dynamic> argumentsMap = _asMap(call.arguments, 'allMaskedValuesForPaymentRequest.args');
    final Map<String, dynamic> requestMap = _decodeRequest(argumentsMap, 'allMaskedValuesForPaymentRequest.request');

    final JsPaymentRequest jsPaymentRequest = await _buildJsPaymentRequest(requestMap);

    final Object maskedValuesJs = js_util.callMethod(jsPaymentRequest, 'getMaskedValues', const []);
    final Map<String, dynamic> maskedValuesMap = (js_util.dartify(maskedValuesJs) as Map).cast<String, dynamic>();

    return jsonEncode(maskedValuesMap);
  }

  Future<String> allUnmaskedValuesForPaymentRequest(MethodCall call) async {
    final Map<String, dynamic> argumentsMap = _asMap(call.arguments, 'allUnmaskedValuesForPaymentRequest.args');
    final Map<String, dynamic> requestMap = _decodeRequest(argumentsMap, 'allUnmaskedValuesForPaymentRequest.request');

    final JsPaymentRequest jsPaymentRequest = await _buildJsPaymentRequest(requestMap);

    final Object unmaskedValuesJs = js_util.callMethod(jsPaymentRequest, 'getUnmaskedValues', const []);
    final Map<String, dynamic> unmaskedValuesMap = (js_util.dartify(unmaskedValuesJs) as Map).cast<String, dynamic>();

    return jsonEncode(unmaskedValuesMap);
  }

  Future<String> maskedValueForAccountOnFile(MethodCall call) async {
    final Map<String, dynamic> argumentsMap = _asMap(call.arguments, 'maskedValueForAccountOnFile.args');
    final Map<String, dynamic> requestMap = _decodeRequest(argumentsMap, 'maskedValueForAccountOnFile');

    final Map<String, dynamic> accountOnFileMap = _asMap(
      requestMap['accountOnFile'],
      'maskedValueForAccountOnFile.accountOnFile',
    );
    final String fieldId = (requestMap['fieldId'] ?? '').toString();

    final String rawValue = _accountOnFileValue(accountOnFileMap, fieldId);

    final JsPaymentRequest jsPaymentRequest = await _buildJsPaymentRequestForSingleField(requestMap, fieldId, rawValue);

    final Object maskedValuesJs = js_util.callMethod(jsPaymentRequest, 'getMaskedValues', const []);
    final Map<String, dynamic> maskedValuesMap = (js_util.dartify(maskedValuesJs) as Map).cast<String, dynamic>();

    return (maskedValuesMap[fieldId] as String?) ?? rawValue;
  }

  Future<JsPaymentRequest> _buildJsPaymentRequest(
    Map<String, dynamic> requestMap,
  ) async {
    JsPaymentProduct jsPaymentProduct;

    if (requestMap['paymentProduct'] is Map) {
      final Map<String, dynamic> productMap = (requestMap['paymentProduct'] as Map).cast<String, dynamic>();
      final JSAny productJson = js_util.jsify(productMap) as JSAny;

      jsPaymentProduct = JsPaymentProduct(productJson);
    } else {
      final int paymentProductId = _requireProductId(requestMap);
      final JsPaymentContext paymentContext = _requireContext(requestMap);
      final JSObject productJsObj =
          await WebSessionStore.require.getPaymentProduct(paymentProductId, paymentContext).toDart;

      jsPaymentProduct = productJsObj as JsPaymentProduct;
    }
    final JsPaymentRequest jsPaymentRequest = JsPaymentRequest()
      ..setPaymentProduct(jsPaymentProduct)
      ..setTokenize((requestMap['tokenize'] as bool?) ?? false);

    final Map<String, dynamic> fieldValues = _extractValues(requestMap);

    fieldValues.forEach((fieldKey, fieldValue) {
      jsPaymentRequest.setValue(fieldKey, (fieldValue ?? '').toString());
    });

    return jsPaymentRequest;
  }

  Future<JsPaymentRequest> _buildJsPaymentRequestForSingleField(
    Map<String, dynamic> originalRequestMap,
    String fieldId,
    String fieldValue,
  ) async {
    final Map<String, dynamic> expandedSingleFieldRequest = <String, dynamic>{
      ...originalRequestMap,
      'fieldValues': <String, dynamic>{fieldId: fieldValue},
      'values': <String, dynamic>{fieldId: fieldValue},
    };

    return _buildJsPaymentRequest(expandedSingleFieldRequest);
  }

  Map<String, dynamic> _extractValues(Map<String, dynamic> requestMap) {
    for (final String candidateKey in const ['values', 'fieldValues', 'data']) {
      final Object? candidateValue = requestMap[candidateKey];
      if (candidateValue is Map) {
        return Map<String, dynamic>.from(candidateValue);
      }
    }

    return <String, dynamic>{};
  }

  String _maskFromField(Map<String, dynamic> fieldMap) {
    final Map<String, dynamic> displayHints = (fieldMap['displayHints'] as Map?)?.cast<String, dynamic>() ?? const {};

    final String mask = (displayHints['mask'] ?? '').toString();

    return mask;
  }

  int _requireProductId(Map<String, dynamic> requestMap) {
    return _toInt(requestMap['paymentProductId'] ?? (requestMap['paymentProduct'] as Map)['id']);
  }

  JsPaymentContext _requireContext(Map<String, dynamic> requestMap) {
    final object = requestMap['paymentContext'];
    if (object is Map) {
      final jsContext = jsPaymentContextFrom(object.cast<String, dynamic>());
      WebSessionStore.setPaymentContext(jsContext);

      return jsContext;
    }

    return WebSessionStore.context!;
  }

  String _accountOnFileValue(Map<String, dynamic> accountOnFileMap, String fieldId) {
    final List<dynamic> attributes = (accountOnFileMap['attributes'] as List?) ?? const [];
    for (final dynamic attributeRaw in attributes) {
      final Map<String, dynamic> attributeMap = Map<String, dynamic>.from(attributeRaw as Map);
      if ((attributeMap['key'] ?? '').toString() == fieldId) {
        return (attributeMap['value'] ?? '').toString();
      }
    }

    return '';
  }

  Map<String, dynamic> _decodeRequest(
    Map<String, dynamic> argumentsMap,
    String contextLabel,
  ) {
    return Map<String, dynamic>.from(jsonDecode(argumentsMap['request'] as String));
  }

  Map<String, dynamic> _asMap(dynamic value, String contextLabel) {
    return (value as Map).cast<String, dynamic>();
  }

  int _toInt(Object? value) {
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
