package com.onlinepayments.client.flutter.online_payments_sdk.sdk.handler

import com.google.gson.Gson
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.models.Result
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.models.ResultError
import com.onlinepayments.sdk.client.android.model.PublicKeyResponse
import com.onlinepayments.sdk.client.android.session.Session
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class PublicKeyHandler(
    private val gson: Gson,
    private val sessionProvider: () -> Session?
) {

    fun getPublicKey(result: MethodChannel.Result) {
        val session = sessionProvider() ?: return ResultError.notInitialized(result)

        CoroutineScope(Dispatchers.IO).launch {
            try {
                val response = session.getPublicKey()
                val sdkResult = Result(data = response)
                val json = gson.toJson(sdkResult)

                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            } catch (e: Throwable) {
                val sdkResult = Result<PublicKeyResponse>(throwable = e)
                val json = gson.toJson(sdkResult)

                withContext(Dispatchers.Main) {
                    result.success(json)
                }
            }
        }
    }
}