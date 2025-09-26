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
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.models.*
import com.onlinepayments.sdk.client.android.exception.EncryptDataException
import com.onlinepayments.sdk.client.android.session.Session
import com.onlinepayments.sdk.client.android.model.PaymentProductNetworkResponse
import com.onlinepayments.sdk.client.android.model.PublicKeyResponse
import com.onlinepayments.sdk.client.android.model.api.ErrorResponse
import com.onlinepayments.sdk.client.android.model.iin.IinDetailsResponse
import com.onlinepayments.sdk.client.android.model.paymentproduct.BasicPaymentProducts
import com.onlinepayments.sdk.client.android.model.paymentproduct.PaymentProduct
import com.onlinepayments.sdk.client.android.model.PreparedPaymentRequest
import com.onlinepayments.sdk.client.android.model.currencyconversion.CurrencyConversionResponse
import com.onlinepayments.sdk.client.android.model.surcharge.response.SurchargeCalculationResponse
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.handler.PublicKeyHandler
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.handler.IinHandler
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.handler.PaymentProductHandler
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.handler.QuoteHandler
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.handler.PaymentRequestHandler
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.handler.SessionHandler

class SdkBridge {
    private val gson = Gson()
    private var session: Session? = null
        set(value) {
            Log.w(TAG, "Setting session to $value")
            field = value
        }

    private val publicKeyHandler = PublicKeyHandler(gson) { session }
    private val iinHandler = IinHandler(gson) { session }
    private val paymentProductHandler = PaymentProductHandler(gson) { session }
    private val quoteHandler = QuoteHandler(gson) { session }
    private val paymentRequestHandler = PaymentRequestHandler(gson) { session }
    private val sessionHandler = SessionHandler(
        sessionSetter = { session = it },
        sessionChecker = { session != null }
    )

    companion object {
        private const val TAG = "SdkBridge"
        private var instance: SdkBridge? = null
        fun getInstance(): SdkBridge {
            return instance ?: SdkBridge().apply {
                instance = this
            }
        }
    }

    fun isSessionInitialized(): Boolean {
        return sessionHandler.isSessionInitialized()
    }

    fun initializeSession(
        context: Context,
        request: InitializeSessionRequest,
    ) {
        sessionHandler.initializeSession(context, request)
    }

    fun getPublicKey(result: MethodChannel.Result) {
        publicKeyHandler.getPublicKey(result)
    }

    fun getIinDetails(result: MethodChannel.Result, request: IinDetailsRequest) {
        iinHandler.getIinDetails(result, request)
    }

    fun getBasicPaymentProducts(
        result: MethodChannel.Result,
        request: BasicPaymentProductsRequest
    ) {
        paymentProductHandler.getBasicPaymentProducts(result, request)
    }

    fun getPaymentProduct(result: MethodChannel.Result, request: PaymentProductRequest) {
        paymentProductHandler.getPaymentProduct(result, request)
    }

    fun getPaymentProductNetworks(
        result: MethodChannel.Result,
        request: PaymentProductNetworksRequest
    ) {
        paymentProductHandler.getPaymentProductNetworks(result, request)
    }

    fun getCurrencyConversionWithPartialCCNumber(
        result: MethodChannel.Result,
        request: CurrencyConversionRequest
    ) {
        quoteHandler.getCurrencyConversionWithPartialCCNumber(result, request)
    }

    fun getCurrencyConversionWithToken(
        result: MethodChannel.Result,
        request: CurrencyConversionRequest
    ) {
        quoteHandler.getCurrencyConversionWithToken(result, request)
    }

    fun getSurchargeCalculationWithPartialCCNumber(
        result: MethodChannel.Result,
        request: SurchargeCalculationRequest
    ) {
        quoteHandler.getSurchargeCalculationWithPartialCCNumber(result, request)
    }

    fun getSurchargeCalculationWithToken(
        result: MethodChannel.Result,
        request: SurchargeCalculationRequest
    ) {
        quoteHandler.getSurchargeCalculationWithToken(result, request)
    }

    fun preparePaymentRequest(result: MethodChannel.Result, request: PreparePaymentRequest) {
        paymentRequestHandler.preparePaymentRequest(result, request)
    }
}