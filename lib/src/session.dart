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
/// Library containing [Session] and its functions.
library session;

import 'dart:convert';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:online_payments_sdk/src/models.dart';
import 'package:online_payments_sdk/src/listeners.dart';
import 'package:online_payments_sdk/src/constants.dart';

part 'native/native_communicator.dart';
part 'native/native_future_interface.dart';
part 'native/native_future.dart';
part 'native/api/native_method_channel.dart';
part 'native/api/native_sdk_interface.dart';

/// Session is used to perform Client API requests, such as get Payment Products and get IIN Details.
final class Session {
  final _NativeCommunicator _nativeSdkCommunicator = _NativeCommunicator();
  bool initialized = false;
  Object? _initializationError;
  Object? get initializationError => _initializationError;

  final String _clientSessionId;
  final String _customerId;
  final String _clientApiUrl;
  final String _assetUrl;
  // Private setter, public get. Named arguments cannot start with _
  final bool isEnvironmentProduction;
  final String appIdentifier;

  // In order for loggingEnabled to fully work as expected; you must either create a NEW session object, or we need to call the methodChannel to update the native SDKs
  bool loggingEnabled = false;

  SdkSessionRequest get _initSessionRequest => SdkSessionRequest(
        _clientSessionId,
        _customerId,
        _clientApiUrl,
        _assetUrl,
        isEnvironmentProduction,
        _getAppIdentifier(),
        loggingEnabled,
      );

  String _getAppIdentifier() {
    return "${Constants.appIdentifierPrefix}/$appIdentifier";
  }

  /// Creates a Session object. Use this object to perform Client API requests such as get Payment Products or get IIN Details.
  Session(
    this._clientSessionId,
    this._customerId,
    this._clientApiUrl,
    this._assetUrl, {
    this.isEnvironmentProduction = false,
    this.appIdentifier = "${Constants.appIdentifierPrefix}/UnknownAppId",
    this.loggingEnabled = false,
  })  : assert(_clientSessionId.isNotEmpty, "Missing clientSessionId"),
        assert(_customerId.isNotEmpty, "Missing customerId"),
        assert(_clientApiUrl.isNotEmpty, "Missing clientApiUrl"),
        assert(_assetUrl.isNotEmpty, "Missing assetUrl") {
    _initNativeSdk();
  }

  Future<void> _initNativeSdk() async {
    final sessionRequest = jsonEncode(_initSessionRequest);
    final result = await _nativeSdkCommunicator
        .createSession(sessionRequest)
        .onError((error, stackTrace) {
      return _initFailed(error);
    });
    initialized = result;
  }

  bool _initFailed(Object? error) {
    _initializationError = error;
    return false;
  }

  /// Retrieves the public key as a [PublicKey] object from the Online Payments gateway.
  getPublicKey({required PublicKeyResponseListener listener}) {
    return _nativeSdkCommunicator.listenForPublicKey(listener).awaitJob();
  }

  /// Retrieves the IinDetails as a [IinDetailsResponse] object from the Online Payments gateway with the use of a [IinDetailsRequest].
  getIinDetails({
    required IinDetailsRequest request,
    required IinLookupResponseListener listener,
  }) {
    return _nativeSdkCommunicator
        .listenForIinDetails(request, listener)
        .awaitJob();
  }

  /// Retrieves the basic payment products as a [BasicPaymentProducts] object from the Online Payments gateway with the use of a [BasicPaymentProductsRequest].
  getBasicPaymentProducts({
    required BasicPaymentProductsRequest request,
    required BasicPaymentProductsResponseListener listener,
  }) {
    return _nativeSdkCommunicator
        .listenForBasicPaymentProducts(request, listener)
        .awaitJob();
  }

  /// Retrieves a payment product as a [PaymentProduct] object from the Online Payments gateway with the use of a [PaymentProductRequest].
  getPaymentProduct({
    required PaymentProductRequest request,
    required PaymentProductResponseListener listener,
  }) {
    return _nativeSdkCommunicator
        .listenForPaymentProduct(request, listener)
        .awaitJob();
  }

  /// Retrieves payment product networks as a [PaymentProductNetworks] object from the Online Payments gateway with the use of a [PaymentProductNetworksRequest].
  getPaymentProductNetworks({
    required PaymentProductNetworksRequest request,
    required PaymentProductNetworksResponseListener listener,
  }) {
    return _nativeSdkCommunicator
        .listenForPaymentProductNetworks(request, listener)
        .awaitJob();
  }

  /// Retrieves a currency conversion quote as a [CurrencyConversion] object from the Online Payments gateway with the use of a [CurrencyConversionRequest].
  getCurrencyConversionQuote({
    required CurrencyConversionRequest request,
    required CurrencyConversionResponseListener listener,
  }) {
    return _nativeSdkCommunicator
        .listenForCurrencyConversionQuote(request, listener)
        .awaitJob();
  }

  /// Retrieves a surcharge calculation as a [SurchargeCalculation] object from the Online Payments gateway with the use of a [SurchargeCalculationRequest].
  getSurchargeCalculation({
    required SurchargeCalculationRequest request,
    required SurchargeCalculationResponseListener listener,
  }) {
    return _nativeSdkCommunicator
        .listenForSurchargeCalculation(request, listener)
        .awaitJob();
  }

  /// Prepares a payment request - supplied as a [SdkPreparePaymentRequest] - used for creating a payment via the Online Payments gateway, it is returned as a [PreparedPaymentRequest].
  preparePaymentRequest({
    required SdkPreparePaymentRequest request,
    required PaymentRequestPreparedListener listener,
  }) {
    return _nativeSdkCommunicator
        .listenForPreparedPaymentRequest(request, listener)
        .awaitJob();
  }
}
