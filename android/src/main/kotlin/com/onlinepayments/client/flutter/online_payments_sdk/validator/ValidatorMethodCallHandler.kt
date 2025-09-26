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
package com.onlinepayments.client.flutter.online_payments_sdk.validator

import com.google.gson.Gson
import com.onlinepayments.client.flutter.online_payments_sdk.extensions.getRequestOrReturnError
import com.onlinepayments.client.flutter.online_payments_sdk.validator.models.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class ValidatorMethodCallHandler(private val gson: Gson) : MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "validatePaymentRequest" -> {
                call.getRequestOrReturnError(
                    PaymentRequestValidationRequest::class.java,
                    result,
                    gson
                )?.apply {
                    Validator.validate(result, this)
                }
            }
            "validatePaymentProductFieldForPaymentRequest" -> {
                call.getRequestOrReturnError(
                    PaymentRequestFieldValidationRequest::class.java,
                    result,
                    gson
                )?.apply {
                    Validator.validate(result, this)
                }
            }
            "validateValueForPaymentProductField" -> {
                call.getRequestOrReturnError(
                    PaymentProductFieldValidationRequest::class.java,
                    result,
                    gson
                )?.apply {
                    Validator.validate(
                        result,
                        this
                    )
                }
            }
            "validateValueForValidationRule" -> {
                call.getRequestOrReturnError(
                    RuleValidationRequest::class.java,
                    result,
                    gson
                )?.apply {
                    Validator.validate(result, this)
                }
            }
            "validatePaymentRequestForValidationRule" -> {
                call.getRequestOrReturnError(
                    PaymentRequestRuleValidationRequest::class.java,
                    result,
                    gson
                )?.apply {
                    Validator.validate(result, this)
                }
            }
            else -> result.notImplemented()
        }
    }
}