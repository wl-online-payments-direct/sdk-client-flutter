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

package com.onlinepayments.client.flutter.online_payments_sdk.sdk.models

data class InitializeSessionRequest(
    val clientSessionId: String,
    val customerId: String,
    val clientApiUrl: String,
    val assetUrl: String,
    val isEnvironmentProduction: Boolean = false,
    val appIdentifier: String,
    val loggingEnabled: Boolean = false,
    val sdkIdentifier: String
)