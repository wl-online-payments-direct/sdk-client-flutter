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
import OnlinePaymentsKit

internal class SdkBridgeMethodCallHandler: OnlinePaymentsPlugin {
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "createSession":
            createSession(call, result)
        case "getPublicKey":
            getPublicKey(result)
        case "getIinDetails":
            getIinDetails(call, result)
        case "getBasicPaymentProducts":
            getBasicPaymentProducts(call, result)
        case "getPaymentProduct":
            getPaymentProduct(call, result)
        case "getPaymentProductNetworks":
            getPaymentProductNetworks(call, result)
        case "getCurrencyConversionQuote":
            getCurrencyConversionQuote(call, result)
        case "getSurchargeCalculation":
            getSurchargeCalculation(call, result)
        case "preparePaymentRequest":
            preparePaymentRequest(call, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func createSession(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        guard let sessionRequest = InitializeSessionRequest.getRequestObject(for: call, result: result) else {
            return
        }

        if let invalidParameterError = assertCreateSessionArguments(session: sessionRequest) {
            result(invalidParameterError)
        }

        SdkBridge.shared.initializeSession(request: sessionRequest)

        result(SdkBridge.shared.isSessionInitialized())
    }

    private func assertCreateSessionArguments(session: InitializeSessionRequest) -> FlutterError? {
        if session.clientSessionId.isEmptyOrWhitespace() {
            return ResultError.invalidParameter(parameter: "clientSessionId")
        } else if session.customerId.isEmptyOrWhitespace() {
            return ResultError.invalidParameter(parameter: "customerId")
        } else if session.clientApiUrl.isEmptyOrWhitespace() {
            return ResultError.invalidParameter(parameter: "clientApiUrl")
        } else if session.assetUrl.isEmptyOrWhitespace() {
            return ResultError.invalidParameter(parameter: "assetUrl")
        } else { return nil }
    }

    private func getPublicKey(_ result: @escaping FlutterResult) {
        if !SdkBridge.shared.isSessionInitialized() {
            result(ResultError.sessionNotInitialized())
            return
        }

        SdkBridge.shared.getPublicKey(result: result)
    }

    private func getIinDetails(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if !SdkBridge.shared.isSessionInitialized() {
            result(ResultError.sessionNotInitialized())
            return
        }

        guard let iinDetailsRequest = IinDetailsRequest.getRequestObject(for: call, result: result) else {
            return
        }

        SdkBridge.shared.getIinDetails(request: iinDetailsRequest, result: result)
    }

    private func getBasicPaymentProducts(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if !SdkBridge.shared.isSessionInitialized() {
            result(ResultError.sessionNotInitialized())
            return
        }

        guard let basicPaymentProductsRequest = BasicPaymentProductsRequest.getRequestObject(for: call, result: result) else {
            return
        }

        SdkBridge.shared.getBasicPaymentProducts(request: basicPaymentProductsRequest, result: result)
    }

    private func getPaymentProduct(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if !SdkBridge.shared.isSessionInitialized() {
            result(ResultError.sessionNotInitialized())
            return
        }

        guard let paymentProductRequest = PaymentProductRequest.getRequestObject(for: call, result: result) else {
            return
        }

        SdkBridge.shared.getPaymentProduct(request: paymentProductRequest, result: result)
    }

    private func getPaymentProductNetworks(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if !SdkBridge.shared.isSessionInitialized() {
            result(ResultError.sessionNotInitialized())
            return
        }

        guard let paymentProductNetworksRequest = PaymentProductNetworksRequest.getRequestObject(for: call, result: result) else {
            return
        }

        SdkBridge.shared.getPaymentProductNetworks(request: paymentProductNetworksRequest, result: result)
    }

    private func getCurrencyConversionQuote(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if !SdkBridge.shared.isSessionInitialized() {
            result(ResultError.sessionNotInitialized())
            return
        }

        guard let currencyConversionRequest = CurrencyConversionRequest.getRequestObject(for: call, result: result) else {
            return
        }

        if currencyConversionRequest.partialCreditCardNumber != nil {
            SdkBridge.shared.getCurrencyConversionWithPartialCCNumber(request: currencyConversionRequest, result: result)
        } else {
            SdkBridge.shared.getCurrencyConversionWithToken(request: currencyConversionRequest, result: result)
        }
    }

    private func getSurchargeCalculation(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if !SdkBridge.shared.isSessionInitialized() {
            result(ResultError.sessionNotInitialized())
            return
        }

        guard let surchargeCalculationRequest = SurchargeCalculationRequest.getRequestObject(for: call, result: result) else {
            return
        }

        if surchargeCalculationRequest.partialCreditCardNumber != nil {
            SdkBridge.shared.getSurchargeCalculationWithPartialCCNumber(request: surchargeCalculationRequest, result: result)
        } else {
            SdkBridge.shared.getSurchargeCalculationWithToken(request: surchargeCalculationRequest, result: result)
        }
    }

    private func preparePaymentRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if !SdkBridge.shared.isSessionInitialized() {
            result(ResultError.sessionNotInitialized())
            return
        }

        guard let paymentRequest = PreparePaymentRequest.getRequestObject(for: call, result: result) else {
            return
        }

        SdkBridge.shared.preparePaymentRequest(request: paymentRequest, result: result)
    }
}
