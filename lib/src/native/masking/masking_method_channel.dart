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

/// An implementation of [_NativeMaskingInterface] that uses method channels.
class _MaskingMethodChannel extends _NativeMaskingInterface {
  /// The method channel used to interact with the native platform.
  final _maskingChannel = const MethodChannel('online_payments_masking');

  @override
  Future<String> applyMaskForPaymentProductField(
      String applyMaskRequest) async {
    final result = await _maskingChannel.invokeMethod(
        'applyMaskForPaymentProductField', {"request": applyMaskRequest});
    return result;
  }

  @override
  Future<String> removeMaskForPaymentProductField(
      String removeMaskRequest) async {
    final result = await _maskingChannel.invokeMethod(
        'removeMaskForPaymentProductField', {"request": removeMaskRequest});
    return result;
  }

  @override
  Future<String> maskedValueForPaymentRequest(String maskedValueRequest) async {
    final result = await _maskingChannel.invokeMethod(
        'maskedValueForPaymentRequest', {"request": maskedValueRequest});
    return result;
  }

  @override
  Future<String> unmaskedValueForPaymentRequest(
      String unmaskedValueRequest) async {
    final result = await _maskingChannel.invokeMethod(
        'unmaskedValueForPaymentRequest', {"request": unmaskedValueRequest});
    return result;
  }

  @override
  Future<String?> allMaskedValuesForPaymentRequest(
      String allMaskedValuesRequest) async {
    final result = await _maskingChannel.invokeMethod(
        'allMaskedValuesForPaymentRequest',
        {"request": allMaskedValuesRequest});
    return result;
  }

  @override
  Future<String?> allUnmaskedValuesForPaymentRequest(
      String allUnmaskedValuesRequest) async {
    final result = await _maskingChannel.invokeMethod(
        'allUnmaskedValuesForPaymentRequest',
        {"request": allUnmaskedValuesRequest});
    return result;
  }

  @override
  Future<String> maskedValueForAccountOnFile(String maskedValueRequest) async {
    final result = await _maskingChannel.invokeMethod(
        'maskedValueForAccountOnFile', {"request": maskedValueRequest});
    return result;
  }

  @override
  Future<String> customMaskedValueForAccountOnFile(
      String customMaskedValueRequest) async {
    final result = await _maskingChannel.invokeMethod(
        'customMaskedValueForAccountOnFile',
        {"request": customMaskedValueRequest});
    return result;
  }
}
