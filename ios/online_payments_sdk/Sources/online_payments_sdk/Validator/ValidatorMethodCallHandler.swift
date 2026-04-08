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

internal class ValidatorMethodCallHandler: OnlinePaymentsPlugin {
    func handle(_ call: FlutterMethodCall, result: FlutterResult) {
        switch call.method {
        case "validatePaymentRequest":
            validatePaymentRequest(call, result)
        case "validatePaymentProductFieldForPaymentRequest":
            validatePaymentProductFieldForPaymentRequest(call, result)
        case "validateValueForPaymentProductField":
            validateValueForPaymentProductField(call, result)
        case "validateValueForValidationRule":
            validateValueForValidationRule(call, result)
        case "validatePaymentRequestForValidationRule":
            validatePaymentRequestPaymentProductFieldForValidationRule(call, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func validatePaymentRequest(_ call: FlutterMethodCall, _ result: FlutterResult) {

        guard let validatePaymentRequestRequest = PaymentRequestValidationRequest.getRequestObject(for: call, result: result) else {
            return
        }

        let validationErrors = validatePaymentRequestRequest.validate()
        validationErrors.forwardResultAsString(encodingErrorType: .validationErrors, result: result)
    }

    private func validatePaymentProductFieldForPaymentRequest(_ call: FlutterMethodCall, _ result: FlutterResult) {

        guard let validatePaymentProductFieldForPaymentRequestRequest = PaymentRequestFieldValidationRequest.getRequestObject(for: call, result: result) else {
            return
        }

        let validationErrors = validatePaymentProductFieldForPaymentRequestRequest.validate()
        validationErrors.forwardResultAsString(encodingErrorType: .validationErrors, result: result)
    }

    private func validateValueForPaymentProductField(_ call: FlutterMethodCall, _ result: FlutterResult) {

        guard let validateValueForPaymentProductField = PaymentProductFieldValidationRequest.getRequestObject(for: call, result: result) else {
            return
        }

        let validationErrors = validateValueForPaymentProductField.validate()
        validationErrors.forwardResultAsString(encodingErrorType: .validationErrors, result: result)
    }

    private func validateValueForValidationRule(_ call: FlutterMethodCall, _ result: FlutterResult) {

        guard let validateValueForValidationRule = RuleValidationRequest.getRequestObject(for: call, result: result) else {
            return
        }

        let validationErrors = validateValueForValidationRule.validate()
        validationErrors.forwardResultAsString(encodingErrorType: .validationErrors, result: result)
    }

    private func validatePaymentRequestPaymentProductFieldForValidationRule(_ call: FlutterMethodCall, _ result: FlutterResult) {

        guard let validatePaymentRequestPaymentProductFieldForValidationRule = PaymentRequestRuleValidationRequest.getRequestObject(for: call, result: result) else {
            return
        }

        let validationErrors = validatePaymentRequestPaymentProductFieldForValidationRule.validate()
        validationErrors.forwardResultAsString(encodingErrorType: .validationErrors, result: result)
    }
}
