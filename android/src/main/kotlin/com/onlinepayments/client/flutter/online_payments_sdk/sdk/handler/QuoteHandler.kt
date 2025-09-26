package com.onlinepayments.client.flutter.online_payments_sdk.sdk.handler

import com.google.gson.Gson
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.models.*
import com.onlinepayments.sdk.client.android.model.currencyconversion.CurrencyConversionResponse
import com.onlinepayments.sdk.client.android.model.surcharge.response.SurchargeCalculationResponse
import com.onlinepayments.sdk.client.android.session.Session
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class QuoteHandler(
    private val gson: Gson,
    private val sessionProvider: () -> Session?
) {

    fun getCurrencyConversionWithPartialCCNumber(
        result: MethodChannel.Result,
        request: CurrencyConversionRequest
    ) {
        val session = sessionProvider() ?: return ResultError.notInitialized(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val response = session.getCurrencyConversionQuote(
                    request.amountOfMoney,
                    request.partialCreditCardNumber!!,
                    request.paymentProductId.toString()
                )
                val sdkResult = Result(data = response)
                val json = gson.toJson(sdkResult)

                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            } catch (e: Throwable) {
                val sdkResult = Result<CurrencyConversionResponse>(throwable = e)
                val json = gson.toJson(sdkResult)

                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            }
        }
    }

    fun getCurrencyConversionWithToken(
        result: MethodChannel.Result,
        request: CurrencyConversionRequest
    ) {
        val session = sessionProvider() ?: return ResultError.notInitialized(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val response = session.getCurrencyConversionQuote(
                    request.amountOfMoney,
                    request.token!!
                )
                val sdkResult = Result(data = response)
                val json = gson.toJson(sdkResult)

                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            } catch (e: Throwable) {
                val sdkResult = Result<CurrencyConversionResponse>(throwable = e)
                val json = gson.toJson(sdkResult)

                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            }
        }
    }

    fun getSurchargeCalculationWithPartialCCNumber(
        result: MethodChannel.Result,
        request: SurchargeCalculationRequest
    ) {
        val session = sessionProvider() ?: return ResultError.notInitialized(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val response = session.getSurchargeCalculation(
                    request.amountOfMoney,
                    request.partialCreditCardNumber!!,
                    request.paymentProductId.toString()
                )
                val sdkResult = Result(data = response)
                val json = gson.toJson(sdkResult)

                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            } catch (e: Throwable) {
                val sdkResult = Result<SurchargeCalculationResponse>(throwable = e)
                val json = gson.toJson(sdkResult)

                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            }
        }
    }

    fun getSurchargeCalculationWithToken(
        result: MethodChannel.Result,
        request: SurchargeCalculationRequest
    ) {
        val session = sessionProvider() ?: return ResultError.notInitialized(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val response = session.getSurchargeCalculation(
                    request.amountOfMoney,
                    request.token!!
                )
                val sdkResult = Result(data = response)
                val json = gson.toJson(sdkResult)

                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            } catch (e: Throwable) {
                val sdkResult = Result<SurchargeCalculationResponse>(throwable = e)
                val json = gson.toJson(sdkResult)

                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            }
        }
    }
}