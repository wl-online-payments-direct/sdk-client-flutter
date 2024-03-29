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
part of '../../masker.dart';

final class PaymentProductFieldMasker {
  static Future<String> applyMask(
      PaymentProductField field, String value) async {
    final applyMaskRequest =
        PaymentProductFieldMaskRequest.applyMask(field, value);
    final maskedValue = await _NativeMaskingInterface.instance
        .applyMaskForPaymentProductField(jsonEncode(applyMaskRequest));
    return maskedValue;
  }

  static Future<String> removeMask(
      PaymentProductField field, String value) async {
    final removeMaskRequest =
        PaymentProductFieldMaskRequest.removeMask(field, value);
    final unmaskedValue = await _NativeMaskingInterface.instance
        .removeMaskForPaymentProductField(jsonEncode(removeMaskRequest));
    return unmaskedValue;
  }
}

final class PaymentProductRequestMasker {
  static Future<String> maskedValue(
      PaymentRequest request, String fieldId) async {
    final maskedValueRequest =
        PaymentRequestMaskedValueRequest.maskedValue(request, fieldId);
    final maskedValue = await _NativeMaskingInterface.instance
        .maskedValueForPaymentRequest(jsonEncode(maskedValueRequest));
    return maskedValue;
  }

  static Future<String> unmaskedValue(
      PaymentRequest request, String fieldId) async {
    final unmaskedValueRequest =
        PaymentRequestMaskedValueRequest.unmaskedValue(request, fieldId);
    final unmaskedValue = await _NativeMaskingInterface.instance
        .unmaskedValueForPaymentRequest(jsonEncode(unmaskedValueRequest));
    return unmaskedValue;
  }

  static Future<String?> maskedValues(PaymentRequest request) async {
    final allMaskedValuesRequest =
        PaymentRequestAllMaskedValuesRequest.maskedValues(request);
    final maskedValues = await _NativeMaskingInterface.instance
        .allMaskedValuesForPaymentRequest(jsonEncode(allMaskedValuesRequest));
    return maskedValues;
  }

  static Future<String?> unmaskedValues(PaymentRequest request) async {
    final allUnmaskedValuesRequest =
        PaymentRequestAllMaskedValuesRequest.unmaskedValues(request);
    final unmaskedValues = await _NativeMaskingInterface.instance
        .allUnmaskedValuesForPaymentRequest(
            jsonEncode(allUnmaskedValuesRequest));
    return unmaskedValues;
  }
}

final class AccountOnFileMasker {
  static Future<String> maskedValue(AccountOnFile aof, String fieldId) async {
    final maskedValueRequest = AccountOnFileMaskedValueRequest(aof, fieldId);
    final maskedValue = await _NativeMaskingInterface.instance
        .maskedValueForAccountOnFile(jsonEncode(maskedValueRequest));
    return maskedValue;
  }

  static Future<String> customMaskedValue(
      AccountOnFile aof, String fieldId, String mask) async {
    final customMaskedValueRequest =
        AccountOnFileCustomMaskedValueRequest(aof, fieldId, mask);
    final customMaskedValue = await _NativeMaskingInterface.instance
        .customMaskedValueForAccountOnFile(
            jsonEncode(customMaskedValueRequest));
    return customMaskedValue;
  }
}
