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
package com.onlinepayments.client.flutter.online_payments_sdk

import com.google.gson.GsonBuilder
import com.onlinepayments.client.flutter.online_payments_sdk.adapters.ValidationRuleTypeAdapter
import com.onlinepayments.client.flutter.online_payments_sdk.validator.ValidatorMethodCallHandler
import com.onlinepayments.client.flutter.online_payments_sdk.masking.MaskingMethodCallHandler
import com.onlinepayments.client.flutter.online_payments_sdk.sdk.SdkBridgeMethodCallHandler
import com.onlinepayments.sdk.client.android.model.validation.AbstractValidationRule

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference


/** OnlinePaymentsPlugin */
class OnlinePaymentsPlugin: FlutterPlugin {

  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private val sdkChannelName = "online_payments_sdk"
  private val validationChannelName = "online_payments_validation"
  private val maskingChannelName = "online_payments_masking"

  private lateinit var apiChannel : MethodChannel
  private lateinit var validationChannel : MethodChannel
  private lateinit var maskingChannel : MethodChannel

  private val gson = GsonBuilder()
    .registerTypeAdapter(AbstractValidationRule::class.java, ValidationRuleTypeAdapter())
    .create()

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val contextReference = WeakReference(flutterPluginBinding.applicationContext)

    apiChannel = MethodChannel(flutterPluginBinding.binaryMessenger, sdkChannelName)
    apiChannel.setMethodCallHandler(SdkBridgeMethodCallHandler(contextReference, gson))

    // Separate validation channel
    validationChannel = MethodChannel(flutterPluginBinding.binaryMessenger, validationChannelName)
    validationChannel.setMethodCallHandler(ValidatorMethodCallHandler(gson))

    // Separate masking channel
    maskingChannel = MethodChannel(flutterPluginBinding.binaryMessenger, maskingChannelName)
    maskingChannel.setMethodCallHandler(MaskingMethodCallHandler(gson))
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    apiChannel.setMethodCallHandler(null)
    validationChannel.setMethodCallHandler(null)
    maskingChannel.setMethodCallHandler(null)
  }
}
