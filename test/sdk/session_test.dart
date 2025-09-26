/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2025 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Session session;
  const MethodChannel mockChannel = MethodChannel('online_payments_sdk');

  void success() {
    expect(true, true);
  }

  Future<Map<String, dynamic>> jsonMap(String filename) async {
    final file = File(filename);
    return jsonDecode(await file.readAsString());
  }

  String jsonString(SdkResult result) {
    final json = result.toJson((value) => value.toJson());
    return jsonEncode(json);
  }

  setUp(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      mockChannel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case "createSession":
            return true;
          case "getPublicKey":
            final PublicKey publicKey =
                PublicKey.fromJson(await jsonMap("test/mock_responses/public_key_response.json"));
            return jsonString(SdkResult(publicKey, null));
          case "getIinDetails":
            final IinDetailsResponse iinDetails =
                IinDetailsResponse.fromJson(await jsonMap("test/mock_responses/iin_details_response.json"));
            return jsonString(SdkResult(iinDetails, null));
          case "getBasicPaymentProducts":
            final BasicPaymentProducts basicPaymentProducts = BasicPaymentProducts.fromJson(
                await jsonMap("test/mock_responses/basic_payment_products_response.json"));
            return jsonString(SdkResult(basicPaymentProducts, null));
          case "getPaymentProduct":
            final PaymentProduct paymentProduct =
                PaymentProduct.fromJson(await jsonMap("test/mock_responses/payment_product_response.json"));
            return jsonString(SdkResult(paymentProduct, null));
          case "getPaymentProductNetworks":
            final PaymentProductNetworks paymentProductNetworks = PaymentProductNetworks.fromJson(
                await jsonMap("test/mock_responses/payment_product_networks_response.json"));
            return jsonString(SdkResult(paymentProductNetworks, null));
          case "getSurchargeCalculation":
            final SurchargeCalculation surchargeCalculation = SurchargeCalculation.fromJson(
                await jsonMap("test/mock_responses/surcharge_calculation_response_with_surcharge.json"));
            return jsonString(SdkResult(surchargeCalculation, null));
          case "preparePaymentRequest":
            final PreparedPaymentRequest preparedPaymentRequest =
                PreparedPaymentRequest.fromJson(await jsonMap("test/mock_responses/prepared_payment_request.json"));
            return jsonString(SdkResult(preparedPaymentRequest, null));
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(mockChannel, null);
  });

  test('createSession', () async {
    session = await createSession();
    expect(session.initialized, true);
  });

  test('getPublicKey', () async {
    await session.getPublicKey(
        listener: PublicKeyResponseListener(onSuccess: (response) {
      success();
    }, onError: (apiError) {
      fail("apiError occurred when retrieving PublicKey: ${apiError?.message}");
    }, onException: (throwable) {
      fail("throwable occurred when retrieving PublicKey: ${throwable?.error}");
    }));
  });

  test('getIinDetails', () async {
    final request = IinDetailsRequest(
        partialCreditCardNumber: "partialCreditCardNumber",
        paymentContext: PaymentContext(AmountOfMoney(200, "USD"), "US", false));

    await session.getIinDetails(
        request: request,
        listener: IinLookupResponseListener(onSuccess: (response) {
          success();
        }, onError: (apiError) {
          fail("apiError occurred when retrieving IinDetails: ${apiError?.message}");
        }, onException: (throwable) {
          fail("throwable occurred when retrieving IinDetails: ${throwable?.error}");
        }));
  });

  test('getBasicPaymentProducts', () async {
    final request = BasicPaymentProductsRequest(paymentContext: PaymentContext(AmountOfMoney(200, "USD"), "US", false));

    await session.getBasicPaymentProducts(
        request: request,
        listener: BasicPaymentProductsResponseListener(onSuccess: (response) {
          success();
        }, onError: (apiError) {
          fail("apiError occurred when retrieving BasicPaymentProducts: ${apiError?.message}");
        }, onException: (throwable) {
          fail("throwable occurred when retrieving BasicPaymentProducts: ${throwable?.error}");
        }));
  });

  test('getPaymentProduct', () async {
    final request =
        PaymentProductRequest(productId: "3", paymentContext: PaymentContext(AmountOfMoney(200, "USD"), "US", false));

    await session.getPaymentProduct(
        request: request,
        listener: PaymentProductResponseListener(onSuccess: (response) {
          success();
        }, onError: (apiError) {
          fail("apiError occurred when retrieving PaymentProduct: ${apiError?.message}");
        }, onException: (throwable) {
          fail("throwable occurred when retrieving PaymentProduct: ${throwable?.error}");
        }));
  });

  test('getPaymentProductNetworks', () async {
    final request = PaymentProductNetworksRequest(
        productId: "3", paymentContext: PaymentContext(AmountOfMoney(200, "USD"), "US", false));

    await session.getPaymentProductNetworks(
        request: request,
        listener: PaymentProductNetworksResponseListener(onSuccess: (response) {
          success();
        }, onError: (apiError) {
          fail("apiError occurred when retrieving PaymentProductNetworks: ${apiError?.message}");
        }, onException: (throwable) {
          fail("throwable occurred when retrieving PaymentProductNetworks: ${throwable?.error}");
        }));
  });

  test('getSurchargeCalculation', () async {
    final request =
        SurchargeCalculationRequest.withToken(AmountOfMoney(1000, "USD"), "SurchargeCalculationRequestToken");

    await session.getSurchargeCalculation(
        request: request,
        listener: SurchargeCalculationResponseListener(onSuccess: (response) {
          success();
        }, onError: (apiError) {
          fail("apiError occurred when retrieving SurchargeCalculation: ${apiError?.message}");
        }, onException: (throwable) {
          fail("throwable occurred when retrieving SurchargeCalculation: ${throwable?.error}");
        }));
  });

  PaymentRequest createPaymentRequest() {
    final List<PaymentProductField> dummyPaymentProductFields = [];
    final PaymentProductDisplayHints dummyDisplayHints =
        PaymentProductDisplayHints("VISA", displayOrder: 0, logoUrl: "VISA_logo");
    final PaymentProduct dummyPaymentProduct = PaymentProduct("1", "card", "cards", false, false, false,
        displayHintsList: [dummyDisplayHints], fields: dummyPaymentProductFields);

    return PaymentRequest(paymentProduct: dummyPaymentProduct, tokenize: false);
  }

  test('preparePaymentRequest', () async {
    final request = SdkPreparePaymentRequest(createPaymentRequest());

    await session.preparePaymentRequest(
        request: request,
        listener: PaymentRequestPreparedListener(onSuccess: (response) {
          success();
        }, onError: (apiError) {
          fail("apiError occurred when preparing PaymentRequest: ${apiError?.message}");
        }, onException: (throwable) {
          fail("throwable occurred when preparing PaymentRequest: ${throwable?.error}");
        }));
  });
}

Future<Session> createSession() async {
  return Future.value(Session("_clientSessionId", "_customerId", "_clientApiUrl", "_assetUrl", loggingEnabled: true));
}
