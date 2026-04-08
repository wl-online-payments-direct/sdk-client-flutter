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
import Flutter

public class OnlinePaymentsPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let apiChannel = FlutterMethodChannel(name: "online_payments_sdk", binaryMessenger: registrar.messenger())
        let apiHandlerInstance = SdkBridgeMethodCallHandler()

        let validatorChannel = FlutterMethodChannel(name: "online_payments_validation", binaryMessenger: registrar.messenger())
        let validatorHandlerInstance = ValidatorMethodCallHandler()

        let maskingChannel = FlutterMethodChannel(name: "online_payments_masking", binaryMessenger: registrar.messenger())
        let maskingHandlerInstance = MaskingMethodCallHandler()

        registrar.addMethodCallDelegate(apiHandlerInstance, channel: apiChannel)
        registrar.addMethodCallDelegate(validatorHandlerInstance, channel: validatorChannel)
        registrar.addMethodCallDelegate(maskingHandlerInstance, channel: maskingChannel)
    }
}
