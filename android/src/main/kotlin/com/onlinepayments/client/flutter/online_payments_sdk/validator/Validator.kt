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
import com.onlinepayments.client.flutter.online_payments_sdk.validator.models.ValidationRequest
import com.onlinepayments.sdk.client.android.model.paymentproduct.PaymentProduct
import com.onlinepayments.sdk.client.android.model.validation.ValidationErrorMessage
import io.flutter.plugin.common.MethodChannel

object Validator {
    private const val TAG = "AndroidValidator"
    private val gson = Gson()

    fun validate(result: MethodChannel.Result, request: ValidationRequest) {
        val errorMessages = request.validate()
        postValidation(errorMessages, result)
    }

    private fun postValidation(errorMessages: List<ValidationErrorMessage>, result: MethodChannel.Result) {
        val resultJson = gson.toJson(errorMessages)
        result.success(resultJson)
    }
}