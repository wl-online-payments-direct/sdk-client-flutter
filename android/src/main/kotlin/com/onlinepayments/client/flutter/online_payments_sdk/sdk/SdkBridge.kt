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
package com.onlinepayments.client.flutter.online_payments_sdk.sdk

import android.content.Context
import android.util.Log
import com.google.gson.Gson
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.models.*
import com.onlinepayments.sdk.client.android.exception.EncryptDataException
import com.onlinepayments.sdk.client.android.listener.BasicPaymentProductsResponseListener
import com.onlinepayments.sdk.client.android.listener.IinLookupResponseListener
import com.onlinepayments.sdk.client.android.listener.PaymentProductNetworkResponseListener
import com.onlinepayments.sdk.client.android.listener.PaymentProductResponseListener
import com.onlinepayments.sdk.client.android.listener.PublicKeyResponseListener
import com.onlinepayments.sdk.client.android.listener.CurrencyConversionResponseListener
import com.onlinepayments.sdk.client.android.listener.SurchargeCalculationResponseListener
import com.onlinepayments.sdk.client.android.listener.PaymentRequestPreparedListener
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

class SdkBridge {
    private val gson = Gson()
    private var session : Session? = null
        set(value) {
            Log.w(TAG, "Setting session to $value")
            field = value
        }

    companion object {
        private const val TAG = "SdkBridge"
        private var instance : SdkBridge? = null
        fun getInstance(): SdkBridge {
            return instance ?: SdkBridge().apply {
                instance = this
            }
        }
    }

    fun isSessionInitialized() : Boolean {
        return session != null
    }

    fun initializeSession(
        request: InitializeSessionRequest,
    ) {
        session =
            Session(
                request.clientSessionId,
                request.customerId,
                request.clientApiUrl,
                request.assetUrl,
                request.isEnvironmentProduction,
                request.appIdentifier,
                request.loggingEnabled
            )
    }

    fun getPublicKey(context: Context, result: io.flutter.plugin.common.MethodChannel.Result) {
        session?.getPublicKey(context, object : PublicKeyResponseListener {
            override fun onSuccess(response: PublicKeyResponse) {
                val sdkResult = Result(data = response)
                val json = gson.toJson(sdkResult)
                result.success(json)
            }

            override fun onApiError(error: ErrorResponse) {
                val sdkResult = Result<PublicKeyResponse>(error = error)
                val json = gson.toJson(sdkResult)
                result.success(json)
            }

            override fun onException(t: Throwable) {
                val sdkResult = Result<PublicKeyResponse>(throwable = t)
                val json = gson.toJson(sdkResult)
                result.success(json)
            }
        }) ?: ResultError.notInitialized(result)
    }

    fun getIinDetails(context: Context, result: io.flutter.plugin.common.MethodChannel.Result, request: IinDetailsRequest) {
        session?.getIinDetails(
            context,
            request.partialCreditCardNumber,
            object : IinLookupResponseListener {
                override fun onSuccess(response: IinDetailsResponse) {
                    val sdkResult = Result(data = response)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }

                override fun onApiError(error: ErrorResponse) {
                    val sdkResult = Result<IinDetailsResponse>(error = error)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }

                override fun onException(t: Throwable) {
                    val sdkResult = Result<IinDetailsResponse>(throwable = t)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }
            },
            request.paymentContext
        ) ?: ResultError.notInitialized(result)
    }

    fun getBasicPaymentProducts(context: Context, result: io.flutter.plugin.common.MethodChannel.Result, request: BasicPaymentProductsRequest) {
        session?.getBasicPaymentProducts(
            context,
            request.paymentContext,
            object : BasicPaymentProductsResponseListener {
                override fun onSuccess(response: BasicPaymentProducts) {
                    val sdkResult = Result(data = response)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }

                override fun onApiError(error: ErrorResponse) {
                    val sdkResult = Result<BasicPaymentProducts>(error = error)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }

                override fun onException(t: Throwable) {
                    val sdkResult = Result<BasicPaymentProducts>(throwable = t)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }
            }
        ) ?: ResultError.notInitialized(result)
    }

    fun getPaymentProduct(context: Context, result: MethodChannel.Result, request: PaymentProductRequest) {
        session?.getPaymentProduct(
            context,
            request.productId,
            request.paymentContext,
            object : PaymentProductResponseListener {
                override fun onSuccess(response: PaymentProduct) {
                    val sdkResult = Result(data = response)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }

                override fun onApiError(error: ErrorResponse) {
                    val sdkResult = Result<PaymentProduct>(error = error)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }

                override fun onException(t: Throwable) {
                    val sdkResult = Result<PaymentProduct>(throwable = t)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }
            }
        ) ?: ResultError.notInitialized(result)
    }

    fun getPaymentProductNetworks(context: Context, result: io.flutter.plugin.common.MethodChannel.Result, request: PaymentProductNetworksRequest) {
        session?.getNetworksForPaymentProduct(
            request.productId,
            context,
            request.paymentContext,
            object : PaymentProductNetworkResponseListener {
                override fun onSuccess(response: PaymentProductNetworkResponse) {
                    val sdkResult = Result(data = response)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }

                override fun onApiError(error: ErrorResponse) {
                    val sdkResult = Result<PaymentProductNetworkResponse>(error = error)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }

                override fun onException(t: Throwable) {
                    val sdkResult = Result<PaymentProductNetworkResponse>(throwable = t)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }
            }
        ) ?: ResultError.notInitialized(result)
    }

    fun getCurrencyConversionWithPartialCCNumber(context: Context, result: io.flutter.plugin.common.MethodChannel.Result, request: CurrencyConversionRequest) {
        session?.getCurrencyConversionQuote(
            context,
            request.amountOfMoney,
            request.partialCreditCardNumber!!,
            request.paymentProductId,
            object : CurrencyConversionResponseListener {
                override fun onSuccess(response: CurrencyConversionResponse) {
                    val sdkResult = Result(data = response)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }

                override fun onApiError(error: ErrorResponse) {
                    val sdkResult = Result<CurrencyConversionResponse>(error = error)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }

                override fun onException(t: Throwable) {
                    val sdkResult = Result<CurrencyConversionResponse>(throwable = t)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }
            }
        ) ?: ResultError.notInitialized(result)
    }

    fun getCurrencyConversionWithToken(context: Context, result: io.flutter.plugin.common.MethodChannel.Result, request: CurrencyConversionRequest) {
        session?.getCurrencyConversionQuote(
            context,
            request.amountOfMoney,
            request.token!!,
            object : CurrencyConversionResponseListener {
                override fun onSuccess(response: CurrencyConversionResponse) {
                    val sdkResult = Result(data = response)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }

                override fun onApiError(error: ErrorResponse) {
                    val sdkResult = Result<CurrencyConversionResponse>(error = error)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }

                override fun onException(t: Throwable) {
                    val sdkResult = Result<CurrencyConversionResponse>(throwable = t)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }
            }
        ) ?: ResultError.notInitialized(result)
    }

    fun getSurchargeCalculationWithPartialCCNumber(context: Context, result: io.flutter.plugin.common.MethodChannel.Result, request: SurchargeCalculationRequest) {
        session?.getSurchargeCalculation(
            context,
            request.amountOfMoney,
            request.partialCreditCardNumber!!,
            request.paymentProductId,
            object : SurchargeCalculationResponseListener {
                override fun onSuccess(response: SurchargeCalculationResponse) {
                    val sdkResult = Result(data = response)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }

                override fun onApiError(error: ErrorResponse) {
                    val sdkResult = Result<SurchargeCalculationResponse>(error = error)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }

                override fun onException(t: Throwable) {
                    val sdkResult = Result<SurchargeCalculationResponse>(throwable = t)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }
            }
        ) ?: ResultError.notInitialized(result)
    }

    fun getSurchargeCalculationWithToken(context: Context, result: io.flutter.plugin.common.MethodChannel.Result, request: SurchargeCalculationRequest) {
        session?.getSurchargeCalculation(
            context,
            request.amountOfMoney,
            request.token!!,
            object : SurchargeCalculationResponseListener {
                override fun onSuccess(response: SurchargeCalculationResponse) {
                    val sdkResult = Result(data = response)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }

                override fun onApiError(error: ErrorResponse) {
                    val sdkResult = Result<SurchargeCalculationResponse>(error = error)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }

                override fun onException(t: Throwable) {
                    val sdkResult = Result<SurchargeCalculationResponse>(throwable = t)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }
            }
        ) ?: ResultError.notInitialized(result)
    }

    fun preparePaymentRequest(context: Context, result: io.flutter.plugin.common.MethodChannel.Result, request: PreparePaymentRequest) {
        session?.preparePaymentRequest(
            request.paymentRequest,
            context,
            object : PaymentRequestPreparedListener {
                override fun onPaymentRequestPrepared(response: PreparedPaymentRequest) {
                    val sdkResult = Result(data = response)
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }

                override fun onFailure(e: EncryptDataException) {
                    val sdkResult = Result<PreparedPaymentRequest>(error = ErrorResponse(e.localizedMessage))
                    val json = gson.toJson(sdkResult)
                    result.success(json)
                }
            }
        ) ?: ResultError.notInitialized(result)
    }
}