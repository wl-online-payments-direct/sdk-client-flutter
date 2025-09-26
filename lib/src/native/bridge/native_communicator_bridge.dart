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

import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/native/api/native_sdk_interface.dart';
import 'package:online_payments_sdk/src/native/bridge/native_future_bridge.dart';
import 'package:online_payments_sdk/src/native/bridge/native_future_interface.dart';

final class NativeCommunicator {
  final NativeSdkInterface bridge;

  NativeCommunicator({required this.bridge});

  Future<bool> createSession(String request) {
    return bridge.createSession(request);
  }

  NativeFuture<PublicKey> listenForPublicKey(
    PublicKeyResponseListener listener,
  ) {
    return NativeFuture(bridge.getPublicKey(), (data) => PublicKey.fromJson(data as Map<String, dynamic>),
        NativeFutureInterface.fromListener(listener));
  }

  NativeFuture<IinDetailsResponse> listenForIinDetails(
    IinDetailsRequest request,
    IinLookupResponseListener listener,
  ) {
    final requestStr = jsonEncode(request);
    return NativeFuture(
        bridge.getIinDetails(requestStr),
        (data) => IinDetailsResponse.fromJson(data as Map<String, dynamic>),
        NativeFutureInterface<IinDetailsResponse>.fromListener(listener));
  }

  NativeFuture<BasicPaymentProducts> listenForBasicPaymentProducts(
    BasicPaymentProductsRequest request,
    BasicPaymentProductsResponseListener listener,
  ) {
    final requestStr = jsonEncode(request);
    return NativeFuture(
        bridge.getBasicPaymentProducts(requestStr),
        (data) => BasicPaymentProducts.fromJson(data as Map<String, dynamic>),
        NativeFutureInterface.fromListener(listener));
  }

  NativeFuture<PaymentProduct> listenForPaymentProduct(
    PaymentProductRequest request,
    PaymentProductResponseListener listener,
  ) {
    final requestStr = jsonEncode(request);
    return NativeFuture(bridge.getPaymentProduct(requestStr),
        (data) => PaymentProduct.fromJson(data as Map<String, dynamic>), NativeFutureInterface.fromListener(listener));
  }

  NativeFuture<PaymentProductNetworks> listenForPaymentProductNetworks(
    PaymentProductNetworksRequest request,
    PaymentProductNetworksResponseListener listener,
  ) {
    final requestStr = jsonEncode(request);
    return NativeFuture(
        bridge.getPaymentProductNetworks(requestStr),
        (data) => PaymentProductNetworks.fromJson(data as Map<String, dynamic>),
        NativeFutureInterface.fromListener(listener));
  }

  NativeFuture<CurrencyConversion> listenForCurrencyConversionQuote(
    CurrencyConversionRequest request,
    CurrencyConversionResponseListener listener,
  ) {
    final requestStr = jsonEncode(request);
    return NativeFuture(
        bridge.getCurrencyConversionQuote(requestStr),
        (data) => CurrencyConversion.fromJson(data as Map<String, dynamic>),
        NativeFutureInterface.fromListener(listener));
  }

  NativeFuture<SurchargeCalculation> listenForSurchargeCalculation(
    SurchargeCalculationRequest request,
    SurchargeCalculationResponseListener listener,
  ) {
    final requestStr = jsonEncode(request);
    return NativeFuture(
        bridge.getSurchargeCalculation(requestStr),
        (data) => SurchargeCalculation.fromJson(data as Map<String, dynamic>),
        NativeFutureInterface.fromListener(listener));
  }

  NativeFuture<PreparedPaymentRequest> listenForPreparedPaymentRequest(
    SdkPreparePaymentRequest request,
    PaymentRequestPreparedListener listener,
  ) {
    final requestStr = jsonEncode(request);
    return NativeFuture(
        bridge.preparePaymentRequest(requestStr),
        (data) => PreparedPaymentRequest.fromJson(data as Map<String, dynamic>),
        NativeFutureInterface.fromListener(listener));
  }
}
