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

import com.onlinepayments.sdk.client.android.model.AmountOfMoney

data class CurrencyConversionRequest(
    val amountOfMoney: AmountOfMoney,
    val partialCreditCardNumber: String?,
    val paymentProductId: Int?,
    val token: String?
)
