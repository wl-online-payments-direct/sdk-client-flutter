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

/// An implementation of [NativeSdkInterface] that uses method channels.
class _ValidationMethodChannel extends _NativeValidationInterface {
  /// The method channel used to interact with the native platform.
  final _validationChannel = const MethodChannel('online_payments_validation');

  @override
  Future<String> validatePaymentRequest(String validationRequest) async {
    final result = await _validationChannel
        .invokeMethod('validatePaymentRequest', {"request": validationRequest});
    return result;
  }

  @override
  Future<String> validatePaymentProductFieldForPaymentRequest(
    String validationRequest,
  ) async {
    final result = await _validationChannel.invokeMethod(
        'validatePaymentProductFieldForPaymentRequest',
        {"request": validationRequest});
    return result;
  }

  @override
  Future<String> validateValueForPaymentProductField(
    String validationRequest,
  ) async {
    final result = await _validationChannel.invokeMethod(
        'validateValueForPaymentProductField', {"request": validationRequest});
    return result;
  }

  @override
  Future<String> validateValueForValidationRule(
    String validationRequest,
  ) async {
    final result = await _validationChannel.invokeMethod(
        'validateValueForValidationRule', {"request": validationRequest});
    return result;
  }

  @override
  Future<String> validatePaymentRequestForValidationRule(
    String validationRequest,
  ) async {
    final result = await _validationChannel.invokeMethod(
        'validatePaymentRequestForValidationRule',
        {"request": validationRequest});
    return result;
  }
}
