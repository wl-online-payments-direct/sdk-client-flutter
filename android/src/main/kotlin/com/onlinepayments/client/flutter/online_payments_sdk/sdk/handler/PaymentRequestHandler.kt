package com.onlinepayments.client.flutter.online_payments_sdk.sdk.handler

import com.google.gson.Gson
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.models.PreparePaymentRequest
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.models.Result
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.models.ResultError
import com.onlinepayments.sdk.client.android.exception.EncryptDataException
import com.onlinepayments.sdk.client.android.model.PreparedPaymentRequest
import com.onlinepayments.sdk.client.android.model.api.ErrorResponse
import com.onlinepayments.sdk.client.android.session.Session
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class PaymentRequestHandler(
    private val gson: Gson,
    private val sessionProvider: () -> Session?
) {

    fun preparePaymentRequest(result: MethodChannel.Result, request: PreparePaymentRequest) {
        val session = sessionProvider() ?: return ResultError.notInitialized(result)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val response = session.preparePaymentRequest(request.paymentRequest)
                val sdkResult = Result(data = response)
                val json = gson.toJson(sdkResult)

                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            } catch (e: EncryptDataException) {
                val errorResponse = ErrorResponse(e.localizedMessage)
                val sdkResult = Result<PreparedPaymentRequest>(error = errorResponse)
                val json = gson.toJson(sdkResult)

                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            } catch (e: Throwable) {
                val sdkResult = Result<PreparedPaymentRequest>(throwable = e)
                val json = gson.toJson(sdkResult)

                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            }
        }
    }
}