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

package com.onlinepayments.client.flutter.online_payments_sdk.validator.models

import com.onlinepayments.client.flutter.online_payments_sdk.validator.Validator
import com.onlinepayments.sdk.client.android.model.validation.ValidationErrorMessage

data class PaymentProductFieldValidationRequest(
    val value: String,
    val fieldId: String
) : ValidationRequest {
    override fun validate(): List<ValidationErrorMessage> {
        return Validator.paymentProduct?.getPaymentProductFieldById(fieldId)?.validateValue(value) ?: listOf(
            ValidationErrorMessage("Payment product not loaded or fieldId not found for $this", fieldId, null)
        )
    }
}