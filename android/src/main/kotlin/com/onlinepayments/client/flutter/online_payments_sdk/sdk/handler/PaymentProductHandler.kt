package com.onlinepayments.client.flutter.online_payments_sdk.sdk.handler

import com.google.gson.Gson
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.models.*
import com.onlinepayments.sdk.client.android.model.paymentproduct.BasicPaymentProducts
import com.onlinepayments.sdk.client.android.model.paymentproduct.PaymentProduct
import com.onlinepayments.sdk.client.android.model.PaymentProductNetworkResponse
import com.onlinepayments.sdk.client.android.session.Session
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class PaymentProductHandler(
    private val gson: Gson,
    private val sessionProvider: () -> Session?
) {

    fun getBasicPaymentProducts(
        result: MethodChannel.Result,
        request: BasicPaymentProductsRequest
    ) {
        val session = sessionProvider() ?: return ResultError.notInitialized(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val response = session.getBasicPaymentProducts(request.paymentContext)
                val sdkResult = Result(data = response)
                val json = gson.toJson(sdkResult)

                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            } catch (e: Throwable) {
                val sdkResult = Result<BasicPaymentProducts>(throwable = e)
                val json = gson.toJson(sdkResult)

                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            }
        }
    }

    fun getPaymentProduct(result: MethodChannel.Result, request: PaymentProductRequest) {
        val session = sessionProvider() ?: return ResultError.notInitialized(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val response = session.getPaymentProduct(
                    request.productId,
                    request.paymentContext
                )
                val sdkResult = Result(data = response)
                val json = gson.toJson(sdkResult)

                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            } catch (e: Throwable) {
                val sdkResult = Result<PaymentProduct>(throwable = e)
                val json = gson.toJson(sdkResult)
                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            }
        }
    }

    fun getPaymentProductNetworks(
        result: MethodChannel.Result,
        request: PaymentProductNetworksRequest
    ) {
        val session = sessionProvider() ?: return ResultError.notInitialized(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val response = session.getNetworksForPaymentProduct(
                    request.productId,
                    request.paymentContext
                )
                val sdkResult = Result(data = response)
                val json = gson.toJson(sdkResult)

                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            } catch (e: Throwable) {
                val sdkResult = Result<PaymentProductNetworkResponse>(throwable = e)
                val json = gson.toJson(sdkResult)
                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            }
        }
    }
}