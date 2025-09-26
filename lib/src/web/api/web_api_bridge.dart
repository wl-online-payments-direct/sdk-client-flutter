import 'dart:convert';
import 'dart:js_interop';

import 'package:js/js_util.dart' as js_util;
import 'package:online_payments_sdk/src/native/api/native_sdk_interface.dart';
import 'package:online_payments_sdk/src/web/bindings/js_session_bindings.dart';
import 'package:online_payments_sdk/src/web/helper/js_helper.dart';
import 'package:online_payments_sdk/src/web/helper/json_stringify.dart';
import 'package:online_payments_sdk/src/web/store/web_session_store.dart';

class WebApiBridge extends NativeSdkInterface {
  late JsSession _jsSession;

  WebApiBridge() : super();

  @override
  Future<bool> createSession(String createSessionRequest) async {
    final map = jsonDecode(createSessionRequest);
    _jsSession = JsSession(JsSessionDetails(
      clientSessionId: map['clientSessionId'],
      customerId: map['customerId'],
      clientApiUrl: map['clientApiUrl'],
      assetUrl: map['assetUrl'],
    ));

    WebSessionStore.set(_jsSession);

    return true;
  }

  JsPaymentContext _buildPaymentContext(Map<String, dynamic> map) {
    final amountOfMoney = map['amountOfMoney'];
    final context = JsPaymentContext(
      amountOfMoney: JsAmountOfMoney(amount: amountOfMoney['amount'], currencyCode: amountOfMoney['currencyCode']),
      countryCode: map['countryCode'],
      isRecurring: map['isRecurring'],
      locale: map['locale'],
    );
    WebSessionStore.setPaymentContext(context);

    return context;
  }

  @override
  Future<String> getBasicPaymentProducts(String basicPaymentProductRequest) async {
    final map = jsonDecode(basicPaymentProductRequest);

    final context = _buildPaymentContext(map['paymentContext']);
    final jsResult = await _jsSession.getBasicPaymentProducts(context).toDart;
    final result = normalizeFields(jsResult.getJsonOrSelf());

    return jsonEncode({
      'status': 'success',
      'data': result,
    });
  }

  @override
  Future<String> getPaymentProduct(String paymentProductRequest) async {
    final map = jsonDecode(paymentProductRequest);

    final id = int.parse(map['productId'].toString());

    final context = _buildPaymentContext(map['paymentContext']);
    final jsResult = await _jsSession.getPaymentProduct(id, context).toDart;
    final result = normalizeFields(jsResult.getJsonOrSelf());

    return jsonEncode({
      'status': 'success',
      'data': result,
    });
  }

  @override
  Future<String> getPublicKey() async {
    final jsResult = await _jsSession.getPublicKey().toDart;
    final result = normalizeFields(jsResult.getJsonOrSelf());

    return jsonEncode({
      'status': 'success',
      'data': result,
    });
  }

  @override
  Future<String> getIinDetails(String iinDetailsRequest) async {
    try {
      final map = jsonDecode(iinDetailsRequest);
      final cardNumber = map['partialCreditCardNumber'].toString();
      final context = _buildPaymentContext(map['paymentContext']);
      final jsResult = await _jsSession.getIinDetails(cardNumber, context).toDart;
      final result = normalizeIinForDart(jsResult);

      return jsonEncode({
        'status': 'success',
        'data': result,
      });
    } catch (e) {
      return jsonEncode({
        'status': 'success',
        'data': {
          'status': 'UNKNOWN',
          'cardType': 'Credit',
          'isAllowedInContext': false,
        }
      });
    }
  }

  @override
  Future<String> getPaymentProductNetworks(String paymentProductNetworksRequest) async {
    final map = jsonDecode(paymentProductNetworksRequest);
    final id = int.parse(map['productId'].toString());

    final context = _buildPaymentContext(map['paymentContext']);
    final jsResult = await _jsSession.getPaymentProductNetworks(id, context).toDart;
    final result = normalizeFields(jsResult.getJsonOrSelf());

    return jsonEncode({
      'status': 'success',
      'data': result,
    });
  }

  @override
  Future<String> getCurrencyConversionQuote(String currencyConversionRequest) async {
    final map = jsonDecode(currencyConversionRequest);
    final amountMap = map['amountOfMoney'];
    final cardOrToken = map['cardOrToken'];
    final amount = JsAmountOfMoney(
      amount: amountMap['amount'],
      currencyCode: amountMap['currencyCode'],
    );

    final jsResult = await _jsSession.getCurrencyConversionQuote(amount, cardOrToken.toJS).toDart;
    final result = normalizeFields(jsResult.getJsonOrSelf());

    return jsonEncode({
      'status': 'success',
      'data': result,
    });
  }

  @override
  Future<String> getSurchargeCalculation(String surchargeCalculationRequest) async {
    final map = jsonDecode(surchargeCalculationRequest);
    final amountMap = map['amountOfMoney'];
    final cardOrToken = map['cardOrToken'];
    final amount = JsAmountOfMoney(
      amount: amountMap['amount'],
      currencyCode: amountMap['currencyCode'],
    );

    final jsResult = await _jsSession.getSurchargeCalculation(amount, cardOrToken.toJS).toDart;
    final result = normalizeFields(jsResult.getJsonOrSelf());

    return jsonEncode({
      'status': 'success',
      'data': result,
    });
  }

  @override
  Future<String> preparePaymentRequest(String paymentRequest) async {
    try {
      final Map<String, dynamic> root = jsonDecode(paymentRequest) as Map<String, dynamic>;
      final Map<String, dynamic> paymentRequestMap = (root['paymentRequest'] as Map).cast<String, dynamic>();

      final dynamic rawId = (paymentRequestMap['paymentProduct'] as Map)['id'] ?? paymentRequestMap['paymentProductId'];

      if (rawId == null) {
        return jsonEncode({
          'status': 'exception',
          'throwable': {'message': 'MISSING_PAYMENT_PRODUCT_ID'}
        });
      }

      final int paymentProductId = rawId is num ? rawId.toInt() : int.parse(rawId.toString());

      final Map<String, dynamic> fieldValues = Map<String, dynamic>.from(paymentRequestMap['fieldValues'] as Map);
      final bool tokenize = (paymentRequestMap['tokenize'] as bool?) ?? false;

      final context = WebSessionStore.context;

      if (context == null) {
        return jsonEncode({
          'status': 'exception',
          'throwable': {'message': 'MISSING_PAYMENT_CONTEXT'}
        });
      }

      final JSObject jsProdObj = await WebSessionStore.require.getPaymentProduct(paymentProductId, context).toDart;
      final JsPaymentProduct paymentProduct = jsProdObj as JsPaymentProduct;

      final request = JsPaymentRequest()
        ..setPaymentProduct(paymentProduct)
        ..setTokenize(tokenize);
      fieldValues.forEach((k, v) => request.setValue(k, v as String?));

      final encryptor = js_util.callMethod(WebSessionStore.require as Object, 'getEncryptor', const []);
      final String jwe =
          await js_util.promiseToFuture<String>(js_util.callMethod(encryptor, 'encrypt', <Object>[request]) as Object);

      return jsonEncode({
        'status': 'success',
        'data': {
          'encryptedFields': jwe,
          'encodedClientMetaInfo': '',
        }
      });
    } catch (e) {
      return jsonEncode({
        'status': 'apiError',
        'throwable': {'message': e.toString()}
      });
    }
  }

  dynamic normalizeFields(dynamic jsValue) {
    final jsonString = jsStringify(jsValue);
    final decodedJson = jsonDecode(jsonString);

    const Set<String> keysThatShouldBeStrings = {
      'id',
      'paymentProductId',
      'accountOnFileId',
      'productId',
      'issuerId',
      'displayHintsId',
    };

    dynamic normalize(dynamic node) {
      if (node is List) {
        return node.map(normalize).toList();
      }

      if (node is Map) {
        final Map<String, dynamic> output = <String, dynamic>{};

        node.forEach((key, rawChildValue) {
          final String stringKey = key.toString();
          var normalizedChild = normalize(rawChildValue);

          if (keysThatShouldBeStrings.contains(stringKey) && normalizedChild is num) {
            normalizedChild = normalizedChild.toString();
          }

          if (stringKey == 'logo' && normalizedChild is String) {
            output['logoUrl'] = normalizedChild;
          }

          output[stringKey] = normalizedChild;
        });

        final dataRestrictions = output['dataRestrictions'];

        if (dataRestrictions is Map) {
          final Map<String, dynamic> dataRest = Map<String, dynamic>.from(dataRestrictions);

          final bool hasRulesList = dataRest['validationRules'] is List;
          final bool hasValidatorsMap = dataRest['validators'] is Map;

          if (!hasRulesList && hasValidatorsMap) {
            final Map<String, dynamic> validatorsMap = Map<String, dynamic>.from(dataRest.remove('validators') as Map);

            final List<Map<String, dynamic>> rules = <Map<String, dynamic>>[];

            validatorsMap.forEach((typeKey, validatorValue) {
              if (validatorValue is Map) {
                final Map<String, dynamic> rule = Map<String, dynamic>.from(validatorValue);

                rule['type'] = typeKey.toString();
                rules.add(rule);
              } else if (validatorValue is bool && validatorValue) {
                rules.add(<String, dynamic>{'type': typeKey.toString()});
              }
            });

            dataRest['validationRules'] = rules;
          }

          final dynamic possibleRules = dataRest['validationRules'];
          if (possibleRules is List) {
            final List<Map<String, dynamic>> normalizedRules = <Map<String, dynamic>>[];
            for (final dynamic ruleNode in possibleRules) {
              if (ruleNode is Map) {
                final Map<String, dynamic> ruleMap = Map<String, dynamic>.from(ruleNode);
                final String ruleTypeLower = (ruleMap['type'] ?? '').toString().toLowerCase();

                String ruleTypeForModel;
                switch (ruleTypeLower) {
                  case 'length':
                    ruleTypeForModel = 'LENGTH';
                    break;
                  case 'luhn':
                    ruleTypeForModel = 'LUHN';
                    break;
                  case 'regularexpression':
                    ruleTypeForModel = 'REGULAREXPRESSION';
                    break;
                  case 'expirationdate':
                    ruleTypeForModel = 'EXPIRATIONDATE';
                    break;
                  default:
                    ruleTypeForModel = ruleTypeLower.toUpperCase();
                    break;
                }

                ruleMap['type'] = ruleTypeForModel;

                ruleMap['messageId'] ??= (ruleTypeLower == 'regularexpression') ? 'regularExpression' : ruleTypeLower;

                if (ruleTypeLower == 'regularexpression') {
                  final bool hasPatternString =
                      ruleMap['pattern'] is String && (ruleMap['pattern'] as String).isNotEmpty;

                  if (!hasPatternString) {
                    String? pickedPattern;
                    if (ruleMap['regularExpression'] is String && (ruleMap['regularExpression'] as String).isNotEmpty) {
                      pickedPattern = ruleMap['regularExpression'] as String;
                    } else if (ruleMap['regex'] is Map && (ruleMap['regex']['pattern'] is String)) {
                      pickedPattern = ruleMap['regex']['pattern'] as String;
                    }
                    ruleMap['pattern'] = pickedPattern ?? '';
                  }
                }

                normalizedRules.add(ruleMap);
              }
            }

            dataRest['validationRules'] = normalizedRules;
          }

          output['dataRestrictions'] = dataRest;
        }

        final formElement = output['formElement'];
        if (formElement is Map && formElement['type'] == 'string') {
          formElement['type'] = 'text';
        }

        return output;
      }

      return node;
    }

    final dynamic normalized = normalize(decodedJson);
    return (normalized is Map) ? normalized.cast<String, dynamic>() : <String, dynamic>{};
  }

  Map<String, dynamic> normalizeIinForDart(dynamic raw) {
    final Map<String, dynamic> normalized = normalizeFields(raw);

    final Map<String, dynamic> defaults = <String, dynamic>{
      'status': 'UNKNOWN',
      'paymentProductId': null,
      'countryCode': null,
      'isAllowedInContext': false,
      'coBrands': <Map<String, dynamic>>[],
      'cardType': 'Credit',
    };

    if (normalized.isEmpty) {
      return defaults;
    }

    final Map<String, dynamic> payload =
        (normalized['json'] is Map) ? Map<String, dynamic>.from(normalized['json'] as Map) : normalized;

    final Map<String, dynamic> result = <String, dynamic>{
      'status': (payload['status'] ?? 'UNKNOWN').toString(),
      'paymentProductId': null,
      'countryCode': null,
      'isAllowedInContext': false,
      'coBrands': <Map<String, dynamic>>[],
      'cardType': 'Credit',
    };

    if (payload['countryCode'] is String) {
      result['countryCode'] = payload['countryCode'] as String;
    }

    if (payload['cardType'] is String) {
      result['cardType'] = payload['cardType'] as String;
    }

    if (payload['coBrands'] is List) {
      final List<Map<String, dynamic>> coBrands = <Map<String, dynamic>>[];
      for (final dynamic item in (payload['coBrands'] as List)) {
        if (item is Map) {
          final Map<String, dynamic> coBrand = Map<String, dynamic>.from(item);
          final dynamic coBrandId = coBrand['paymentProductId'];
          if (coBrandId is num) {
            coBrand['paymentProductId'] = coBrandId.toString();
          }

          coBrands.add(coBrand);
        }
      }

      result['coBrands'] = coBrands;
    }

    return result;
  }
}
