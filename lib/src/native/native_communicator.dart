/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2023 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
part of '../session.dart';

final class _NativeCommunicator {
  Future<bool> createSession(String request) {
    return _NativeSdkInterface.instance.createSession(request);
  }

  _NativeFuture<PublicKey> listenForPublicKey(
      PublicKeyResponseListener listener) {
    return _NativeFuture(
        _NativeSdkInterface.instance.getPublicKey(),
        (data) => PublicKey.fromJson(data as Map<String, dynamic>),
        _NativeFutureInterface.fromListener(listener));
  }

  _NativeFuture<IinDetailsResponse> listenForIinDetails(
      IinDetailsRequest request, IinLookupResponseListener listener) {
    final requestStr = jsonEncode(request);
    return _NativeFuture(
        _NativeSdkInterface.instance.getIinDetails(requestStr),
        (data) => IinDetailsResponse.fromJson(data as Map<String, dynamic>),
        _NativeFutureInterface<IinDetailsResponse>.fromListener(listener));
  }

  _NativeFuture<BasicPaymentProducts> listenForBasicPaymentProducts(
      BasicPaymentProductsRequest request,
      BasicPaymentProductsResponseListener listener) {
    final requestStr = jsonEncode(request);
    return _NativeFuture(
        _NativeSdkInterface.instance.getBasicPaymentProducts(requestStr),
        (data) => BasicPaymentProducts.fromJson(data as Map<String, dynamic>),
        _NativeFutureInterface.fromListener(listener));
  }

  _NativeFuture<PaymentProduct> listenForPaymentProduct(
      PaymentProductRequest request, PaymentProductResponseListener listener) {
    final requestStr = jsonEncode(request);
    return _NativeFuture(
        _NativeSdkInterface.instance.getPaymentProduct(requestStr),
        (data) => PaymentProduct.fromJson(data as Map<String, dynamic>),
        _NativeFutureInterface.fromListener(listener));
  }

  _NativeFuture<PaymentProductNetworks> listenForPaymentProductNetworks(
      PaymentProductNetworksRequest request,
      PaymentProductNetworksResponseListener listener) {
    final requestStr = jsonEncode(request);
    return _NativeFuture(
        _NativeSdkInterface.instance.getPaymentProductNetworks(requestStr),
        (data) => PaymentProductNetworks.fromJson(data as Map<String, dynamic>),
        _NativeFutureInterface.fromListener(listener));
  }

  _NativeFuture<CurrencyConversion> listenForCurrencyConversionQuote(
      CurrencyConversionRequest request,
      CurrencyConversionResponseListener listener) {
    final requestStr = jsonEncode(request);
    return _NativeFuture(
        _NativeSdkInterface.instance.getCurrencyConversionQuote(requestStr),
        (data) => CurrencyConversion.fromJson(data as Map<String, dynamic>),
        _NativeFutureInterface.fromListener(listener));
  }

  _NativeFuture<SurchargeCalculation> listenForSurchargeCalculation(
      SurchargeCalculationRequest request,
      SurchargeCalculationResponseListener listener) {
    final requestStr = jsonEncode(request);
    return _NativeFuture(
        _NativeSdkInterface.instance.getSurchargeCalculation(requestStr),
        (data) => SurchargeCalculation.fromJson(data as Map<String, dynamic>),
        _NativeFutureInterface.fromListener(listener));
  }

  _NativeFuture<PreparedPaymentRequest> listenForPreparedPaymentRequest(
      SdkPreparePaymentRequest request,
      PaymentRequestPreparedListener listener) {
    final requestStr = jsonEncode(request);
    return _NativeFuture(
        _NativeSdkInterface.instance.preparePaymentRequest(requestStr),
        (data) => PreparedPaymentRequest.fromJson(data as Map<String, dynamic>),
        _NativeFutureInterface.fromListener(listener));
  }
}
