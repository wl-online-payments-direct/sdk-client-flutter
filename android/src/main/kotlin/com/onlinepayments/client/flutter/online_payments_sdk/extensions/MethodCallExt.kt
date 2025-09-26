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

package com.onlinepayments.client.flutter.online_payments_sdk.extensions

import com.google.gson.Gson
import com.google.gson.JsonSyntaxException
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.models.ResultError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

fun <T> MethodCall.getRequestOrReturnError(type: Class<T>, result: MethodChannel.Result, gson: Gson, argumentKey: String = "request") : T? {
    val json = argument<String>(argumentKey)
    return try {
        gson.fromJson(json, type)
    } catch (e: JsonSyntaxException) {
        ResultError.missingRequestArgument(this, result, e)
        null
    }
}