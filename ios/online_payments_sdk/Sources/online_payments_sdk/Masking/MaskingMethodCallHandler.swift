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

internal class MaskingMethodCallHandler: OnlinePaymentsPlugin {
    func handle(_ call: FlutterMethodCall, result: FlutterResult) {
        switch call.method {
        case "applyMaskForPaymentProductField":
            applyMaskForPaymentProductField(call, result)
        case "removeMaskForPaymentProductField":
            removeMaskForPaymentProductField(call, result)
        case "maskedValueForPaymentRequest":
            maskedValueForPaymentRequest(call, result)
        case "unmaskedValueForPaymentRequest":
            unmaskedValueForPaymentRequest(call, result)
        case "allMaskedValuesForPaymentRequest":
            allMaskedValuesForPaymentRequest(call, result)
        case "allUnmaskedValuesForPaymentRequest":
            allUnmaskedValuesForPaymentRequest(call, result)
        case "maskedValueForAccountOnFile":
            maskedValueForAccountOnFile(call, result)
        case "customMaskedValueForAccountOnFile":
            customMaskedValueForAccountOnFile(call, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func applyMaskForPaymentProductField(_ call: FlutterMethodCall, _ result: FlutterResult) {

        guard let paymentProductFieldMaskRequest = PaymentProductFieldMaskRequest.getRequestObject(for: call, result: result) else {
            return
        }

        let field = paymentProductFieldMaskRequest.field
        let value = paymentProductFieldMaskRequest.value

        let maskedValue = field.applyMask(value: value)
        result(maskedValue)
    }

    private func removeMaskForPaymentProductField(_ call: FlutterMethodCall, _ result: FlutterResult) {

        guard let paymentProductFieldMaskRequest = PaymentProductFieldMaskRequest.getRequestObject(for: call, result: result) else {
            return
        }

        let field = paymentProductFieldMaskRequest.field
        let value = paymentProductFieldMaskRequest.value

        let unmaskedValue = field.removeMask(value: value)
        result(unmaskedValue)
    }

    private func maskedValueForPaymentRequest(_ call: FlutterMethodCall, _ result: FlutterResult) {

        guard let paymentRequestMaskedValueRequest = PaymentRequestMaskedValueRequest.getRequestObject(for: call, result: result) else {
            return
        }

        let request = paymentRequestMaskedValueRequest.request
        let fieldId = paymentRequestMaskedValueRequest.fieldId

        let maskedValue = request.maskedValue(forField: fieldId)
        result(maskedValue)
    }

    private func unmaskedValueForPaymentRequest(_ call: FlutterMethodCall, _ result: FlutterResult) {

        guard let paymentRequestMaskedValueRequest = PaymentRequestMaskedValueRequest.getRequestObject(for: call, result: result) else {
            return
        }

        let request = paymentRequestMaskedValueRequest.request
        let fieldId = paymentRequestMaskedValueRequest.fieldId

        let unmaskedValue = request.unmaskedValue(forField: fieldId)
        result(unmaskedValue)
    }

    private func allMaskedValuesForPaymentRequest(_ call: FlutterMethodCall, _ result: FlutterResult) {

        guard let paymentRequestAllMaskedValuesRequest = PaymentRequestAllMaskedValuesRequest.getRequestObject(for: call, result: result) else {
            return
        }

        let request = paymentRequestAllMaskedValuesRequest.request

        guard let allMaskedValues = request.maskedFieldValues else {
            result(nil)
            return
        }

        allMaskedValues.forwardResultAsString(encodingErrorType: .maskedValuesDictionary, result: result)
    }

    private func allUnmaskedValuesForPaymentRequest(_ call: FlutterMethodCall, _ result: FlutterResult) {

        guard let paymentRequestAllUnmaskedValuesRequest = PaymentRequestAllMaskedValuesRequest.getRequestObject(for: call, result: result) else {
            return
        }

        let request = paymentRequestAllUnmaskedValuesRequest.request

        guard let allUnmaskedValues = request.unmaskedFieldValues else {
            result(nil)
            return
        }

        allUnmaskedValues.forwardResultAsString(encodingErrorType: .unmaskedValuesDictionary, result: result)
    }
    
    private func maskedValueForAccountOnFile(_ call: FlutterMethodCall, _ result: FlutterResult) {

        guard let accountOnFileMaskRequest = AccountOnFileMaskedValueRequest.getRequestObject(for: call, result: result) else {
            return
        }

        let accountOnFile = accountOnFileMaskRequest.accountOnFile
        let fieldId = accountOnFileMaskRequest.fieldId
        
        let maskedValue = accountOnFile.maskedValue(forField: fieldId)
        result(maskedValue)
    }
    
    private func customMaskedValueForAccountOnFile(_ call: FlutterMethodCall, _ result: FlutterResult) {

        guard let accountOnFileCustomMaskRequest = AccountOnFileCustomMaskedValueRequest.getRequestObject(for: call, result: result) else {
            return
        }

        let accountOnFile = accountOnFileCustomMaskRequest.accountOnFile
        let fieldId = accountOnFileCustomMaskRequest.fieldId
        let mask = accountOnFileCustomMaskRequest.mask
        
        let maskedValue = accountOnFile.maskedValue(forField: fieldId, mask: mask)
        result(maskedValue)
    }
}
