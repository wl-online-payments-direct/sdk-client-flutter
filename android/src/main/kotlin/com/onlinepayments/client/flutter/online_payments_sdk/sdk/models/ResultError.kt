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

package com.onlinepayments.client.flutter.online_payments_sdk.sdk.models

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.security.InvalidParameterException

data class ResultError(val code : String, val message: String) {
    companion object {
        enum class ResultErrorCode(val id: String) {
            NOT_INITIALIZED("1"),
            MISSING_REQUEST_ARGUMENT("2"),
            MISSING_REQUIRED_ARGUMENT("3"),
            MISSING_CONTEXT("4"),
        }
        fun missingRequestArgument(call: MethodCall, result: MethodChannel.Result, e: Exception?) {
            return result.error(ResultErrorCode.MISSING_REQUEST_ARGUMENT.id, "Missing the required request argument for request : ${call.method}", e)
        }

        fun notInitialized(result: MethodChannel.Result) {
            return result.error(ResultErrorCode.NOT_INITIALIZED.id, "Session is null, did you forget to initialize it?", null)
        }

        fun missingRequiredArgument(call: MethodCall, result: MethodChannel.Result, e: InvalidParameterException? = null) {
            return result.error(ResultErrorCode.MISSING_REQUIRED_ARGUMENT.id, "Missing a required argument in the request for method : ${call.method}", e)
        }

        fun missingContext(call: MethodCall, result: MethodChannel.Result) {
            return result.error(ResultErrorCode.MISSING_CONTEXT.id, "No context available to execute method : ${call.method}", null)
        }
    }
}
