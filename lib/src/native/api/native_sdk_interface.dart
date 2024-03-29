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

abstract class _NativeSdkInterface extends PlatformInterface {
  /// Constructs a OnlinepaymentsSdkFlutterPlatform.
  _NativeSdkInterface() : super(token: _token);

  static final Object _token = Object();

  static final _NativeSdkInterface _apiCallChannel = _NativeApiMethodChannel();

  /// The default instance of [_NativeSdkInterface] to use.
  ///
  /// Defaults to [_NativeApiMethodChannel].
  static _NativeSdkInterface get instance => _apiCallChannel;

  Future<String> getPublicKey() {
    throw UnimplementedError('GetPublicKey() has not been implemented');
  }

  Future<bool> createSession(String createSessionRequest) {
    throw UnimplementedError('Get Session has not been implemented.');
  }

  Future<String> getIinDetails(String iinDetailsRequest) {
    throw UnimplementedError('Get Iin Details call has not been implemented');
  }

  Future<String> getBasicPaymentProducts(String basicPaymentProductRequest) {
    throw UnimplementedError(
        'Get Basic Payment Products call has not been implemented');
  }

  Future<String> getPaymentProduct(String paymentProductRequest) {
    throw UnimplementedError(
        'Get Payment Product by id has not been implemented');
  }

  Future<String> getPaymentProductNetworks(
      String paymentProductNetworksRequest) {
    throw UnimplementedError(
        'Get Payment Product Networks has not been implemented');
  }

  Future<String> getCurrencyConversionQuote(String currencyConversionRequest) {
    throw UnimplementedError(
        'Get Currency Conversion has not been implemented');
  }

  Future<String> getSurchargeCalculation(String surchargeCalculationRequest) {
    throw UnimplementedError(
        'Get Surcharge Calculation has not been implemented');
  }

  Future<String> preparePaymentRequest(String paymentRequest) {
    throw UnimplementedError(
        'Prepare Payment Request has not been implemented');
  }
}
