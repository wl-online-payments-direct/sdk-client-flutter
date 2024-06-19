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
part of '../../session.dart';

/// An implementation of [_NativeSdkInterface] that uses method channels.
class _NativeApiMethodChannel extends _NativeSdkInterface {
  /// The method channel used to interact with the native platform.
  final _methodChannel = const MethodChannel('online_payments_sdk');

  @override
  Future<String> getPublicKey() async {
    final result = await _methodChannel.invokeMethod('getPublicKey');
    return result;
  }

  @override
  Future<bool> createSession(String createSessionRequest) async {
    final result = await _methodChannel
        .invokeMethod('createSession', {"request": createSessionRequest});
    return result;
  }

  @override
  Future<String> getIinDetails(String iinDetailsRequest) async {
    final result = await _methodChannel
        .invokeMethod('getIinDetails', {"request": iinDetailsRequest});
    return result;
  }

  @override
  Future<String> getBasicPaymentProducts(
    String basicPaymentProductRequest,
  ) async {
    final result = await _methodChannel.invokeMethod(
        'getBasicPaymentProducts', {"request": basicPaymentProductRequest});
    return result;
  }

  @override
  Future<String> getPaymentProduct(String paymentProductRequest) async {
    final result = await _methodChannel
        .invokeMethod('getPaymentProduct', {"request": paymentProductRequest});
    return result;
  }

  @override
  Future<String> getPaymentProductNetworks(
    String paymentProductNetworksRequest,
  ) async {
    final result = await _methodChannel.invokeMethod(
        'getPaymentProductNetworks',
        {"request": paymentProductNetworksRequest});
    return result;
  }

  @override
  Future<String> getCurrencyConversionQuote(
    String currencyConversionRequest,
  ) async {
    final result = await _methodChannel.invokeMethod(
        'getCurrencyConversionQuote', {"request": currencyConversionRequest});
    return result;
  }

  @override
  Future<String> getSurchargeCalculation(
    String surchargeCalculationRequest,
  ) async {
    final result = await _methodChannel.invokeMethod(
        'getSurchargeCalculation', {"request": surchargeCalculationRequest});
    return result;
  }

  @override
  Future<String> preparePaymentRequest(String paymentRequest) async {
    final result = await _methodChannel
        .invokeMethod('preparePaymentRequest', {"request": paymentRequest});
    return result;
  }
}
