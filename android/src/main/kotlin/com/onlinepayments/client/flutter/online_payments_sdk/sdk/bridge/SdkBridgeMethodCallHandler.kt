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
package com.onlinepayments.client.flutter.online_payments_sdk.sdk

import android.content.Context
import android.util.Log
import com.google.gson.Gson
import com.onlinepayments.client.flutter.online_payments_sdk.extensions.getRequestOrReturnError
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.models.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference
import java.security.InvalidParameterException
class SdkBridgeMethodCallHandler(private val contextReference: WeakReference<Context>, private val gson: Gson)
    : MethodChannel.MethodCallHandler {
    companion object {
        private const val TAG = "ApiCallMethodHandler"
    }

    private val applicationContext get() = contextReference.get()
    private val bridge get() = SdkBridge.getInstance()
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "createSession" -> createSession(call, result)
            "getPublicKey" -> getPublicKey(call, result)
            "getIinDetails" -> getIinDetails(call, result)
            "getBasicPaymentProducts" -> getBasicPaymentProducts(call, result)
            "getPaymentProduct" -> getPaymentProduct(call, result)
            "getPaymentProductNetworks" -> getPaymentProductNetworks(call, result)
            "getCurrencyConversionQuote" -> getCurrencyConversionQuote(call, result)
            "getSurchargeCalculation" -> getSurchargeCalculation(call, result)
            "preparePaymentRequest" -> preparePaymentRequest(call, result)
            else -> result.notImplemented()
        }
    }

    private fun preparePaymentRequest(call: MethodCall, result: MethodChannel.Result) {
        val context = applicationContext
        val request = call.getRequestOrReturnError(PreparePaymentRequest::class.java, result, gson)
        request ?: return

        if (!bridge.isSessionInitialized()) {
            return ResultError.notInitialized(result)
        }

        if (context == null) {
            return ResultError.missingContext(call, result)
        }

        bridge.preparePaymentRequest(result, request)
    }

    private fun getCurrencyConversionQuote(call: MethodCall, result: MethodChannel.Result) {
        val context = applicationContext
        val request = call.getRequestOrReturnError(CurrencyConversionRequest::class.java, result, gson)
        request ?: return

        if (!bridge.isSessionInitialized()) {
            return ResultError.notInitialized(result)
        }

        if (context == null) {
            return ResultError.missingContext(call, result)
        }

        if (request.partialCreditCardNumber != null) {
            bridge.getCurrencyConversionWithPartialCCNumber(result, request)
        } else if (request.token != null) {
            bridge.getCurrencyConversionWithToken(result, request)
        } else {
            return ResultError.missingRequestArgument(call, result, null)
        }
    }

    private fun getSurchargeCalculation(call: MethodCall, result: MethodChannel.Result) {
        val context = applicationContext
        val request = call.getRequestOrReturnError(SurchargeCalculationRequest::class.java, result, gson)
        request ?: return

        if (!bridge.isSessionInitialized()) {
            return ResultError.notInitialized(result)
        }

        if (context == null) {
            return ResultError.missingContext(call, result)
        }

        if (request.partialCreditCardNumber != null) {
            bridge.getSurchargeCalculationWithPartialCCNumber(result, request)
        } else if (request.token != null) {
            bridge.getSurchargeCalculationWithToken(result, request)
        } else {
            return ResultError.missingRequestArgument(call, result, null)
        }
    }

    private fun getPaymentProductNetworks(call: MethodCall, result: MethodChannel.Result) {
        val context = applicationContext
        val request = call.getRequestOrReturnError(PaymentProductNetworksRequest::class.java, result, gson)
        request ?: return

        if (!bridge.isSessionInitialized()) {
            return ResultError.notInitialized(result)
        }

        if (context == null) {
            return ResultError.missingContext(call, result)
        }

        bridge.getPaymentProductNetworks(result, request)
    }

    private fun getPaymentProduct(call: MethodCall, result: MethodChannel.Result) {
        val context = applicationContext
        val request = call.getRequestOrReturnError(PaymentProductRequest::class.java, result, gson)
        request ?: return

        if (!bridge.isSessionInitialized()) {
            return ResultError.notInitialized(result)
        }

        if (context == null) {
            return ResultError.missingContext(call, result)
        }

        bridge.getPaymentProduct(result, request)
    }

    private fun getBasicPaymentProducts(call: MethodCall, result: MethodChannel.Result) {
        val context = applicationContext
        val request = call.getRequestOrReturnError(BasicPaymentProductsRequest::class.java, result, gson)
        request ?: return

        if (!bridge.isSessionInitialized()) {
            return ResultError.notInitialized(result)
        }

        if (context == null) {
            return ResultError.missingContext(call, result)
        }

        bridge.getBasicPaymentProducts(result, request)
    }

    private fun getIinDetails(call: MethodCall, result: MethodChannel.Result) {
        val context = applicationContext
        val request = call.getRequestOrReturnError(IinDetailsRequest::class.java, result, gson)
        request ?: return

        if (!bridge.isSessionInitialized()) {
            return ResultError.notInitialized(result)
        }

        if (context == null) {
            return ResultError.missingContext(call, result)
        }

        bridge.getIinDetails(result, request)
    }

    private fun getPublicKey(call: MethodCall, result: MethodChannel.Result) {
        val context = applicationContext

        if (!bridge.isSessionInitialized()) {
            return ResultError.notInitialized(result)
        }

        if (context == null) {
            return ResultError.missingContext(call, result)
        }

        bridge.getPublicKey(result)
    }

    private fun createSession(call: MethodCall, result: MethodChannel.Result) {
        val request = call.getRequestOrReturnError(InitializeSessionRequest::class.java, result, gson)
        request ?: return

        assertCreateSessionArguments(request)?.let {
            ResultError.missingRequiredArgument(call, result, it)
        } ?: run {
            // No error found while checking arguments
            val context = applicationContext ?: return ResultError.missingContext(call, result)
            bridge.initializeSession(context, request)
            result.success(bridge.isSessionInitialized())
        }
    }

    private fun assertCreateSessionArguments(request: InitializeSessionRequest) : InvalidParameterException? {
        with (request) {
            val error = when {
                clientSessionId.isBlank() -> InvalidParameterException("clientSessionId")
                customerId.isBlank() -> InvalidParameterException("customerId")
                clientApiUrl.isBlank() -> InvalidParameterException("clientApiUrl")
                assetUrl.isBlank() -> InvalidParameterException("assetUrl")
                isEnvironmentProduction && loggingEnabled -> {
                    Log.w(TAG, "The combination of a production environment and enabled logging is highly ill-advised. Proceed with caution")
                    null
                }
                else -> null
            }
            return error
        }
    }
}