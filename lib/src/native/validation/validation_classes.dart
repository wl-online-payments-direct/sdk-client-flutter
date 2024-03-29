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
part of '../../validator.dart';

final class PaymentRequestValidator {
  static Future<List<ValidationErrorMessage>> validatePaymentRequest(
      PaymentRequest request) async {
    final validationRequest = PaymentRequestValidationRequest(request);
    final validationResultStr = await _NativeValidationInterface.instance
        .validatePaymentRequest(jsonEncode(validationRequest));
    return _parseValidationErrorMessages(validationResultStr);
  }

  static Future<List<ValidationErrorMessage>>
      validatePaymentProductFieldForPaymentRequest(
          String fieldId, PaymentRequest paymentRequest) async {
    final validationRequest =
        PaymentRequestValidationRequest(paymentRequest, fieldId: fieldId);
    final validationResultStr = await _NativeValidationInterface.instance
        .validatePaymentProductFieldForPaymentRequest(
            jsonEncode(validationRequest));
    return _parseValidationErrorMessages(validationResultStr);
  }
}

final class PaymentProductFieldValidator {
  static Future<List<ValidationErrorMessage>>
      validateValueForPaymentProductField(
          String value, PaymentProductField field) async {
    final validationRequest =
        PaymentProductFieldValidationRequest(value, field);
    final validationResultStr = await _NativeValidationInterface.instance
        .validateValueForPaymentProductField(jsonEncode(validationRequest));
    return _parseValidationErrorMessages(validationResultStr);
  }
}

final class ValidationRuleValidator {
  static Future<List<ValidationErrorMessage>> validateValueForValidationRule(
      String value, ValidationRule rule) async {
    final validationRequest = ValidationRuleValidationRequest(value, rule);
    final validationResultStr = await _NativeValidationInterface.instance
        .validateValueForValidationRule(jsonEncode(validationRequest));
    return _parseValidationErrorMessages(validationResultStr);
  }

  static Future<List<ValidationErrorMessage>>
      validateValidationRuleForPaymentRequestAndFieldId(
          PaymentRequest request, String fieldId, ValidationRule rule) async {
    final validationRequest =
        PaymentRequestRuleValidationRequest(request, fieldId, rule);
    final validationResultStr = await _NativeValidationInterface.instance
        .validatePaymentRequestForValidationRule(jsonEncode(validationRequest));
    return _parseValidationErrorMessages(validationResultStr);
  }
}

List<ValidationErrorMessage> _parseValidationErrorMessages(
    String validationResultStr) {
  List<dynamic> json = jsonDecode(validationResultStr);

  final validationResult =
      json.map((vem) => ValidationErrorMessage.fromJson(vem));
  final result = validationResult.toList(growable: false);
  return result;
}
