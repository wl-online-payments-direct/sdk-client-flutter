package com.onlinepayments.client.flutter.online_payments_sdk.sdk.handler

import android.content.Context
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.models.InitializeSessionRequest
import com.onlinepayments.sdk.client.android.session.Session

class SessionHandler(
    private val sessionSetter: (Session) -> Unit,
    private val sessionChecker: () -> Boolean
) {
    fun initializeSession(context: Context, request: InitializeSessionRequest) {
        val session = Session(
            request.clientSessionId,
            request.customerId,
            request.clientApiUrl,
            request.assetUrl,
            request.isEnvironmentProduction,
            request.appIdentifier,
            request.loggingEnabled,
            request.sdkIdentifier,
            context
        )

        sessionSetter(session)
    }

    fun isSessionInitialized(): Boolean = sessionChecker()
}