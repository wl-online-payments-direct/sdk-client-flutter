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
part of 'validator.dart';

/// An implementation of [NativeSdkInterface] that uses method channels.
class _ValidationMethodChannel extends _NativeValidationInterface {
  /// The method channel used to interact with the native platform.
  final _validationChannel = const MethodChannel('online_payments_validation');

  @override
  Future<String> validatePaymentRequest(String validationRequest) async {
    return await invokeMethod('validatePaymentRequest', validationRequest);
  }

  @override
  Future<String> validatePaymentProductFieldForPaymentRequest(
    String validationRequest,
  ) async {
    return await invokeMethod('validatePaymentProductFieldForPaymentRequest', validationRequest);
  }

  @override
  Future<String> validateValueForPaymentProductField(
    String validationRequest,
  ) async {
    return await invokeMethod('validateValueForPaymentProductField', validationRequest);
  }

  @override
  Future<String> validateValueForValidationRule(
    String validationRequest,
  ) async {
    return await invokeMethod('validateValueForValidationRule', validationRequest);
  }

  @override
  Future<String> validatePaymentRequestForValidationRule(
    String validationRequest,
  ) async {
    return await invokeMethod('validatePaymentRequestForValidationRule', validationRequest);
  }

  Future<String> invokeMethod(
    String name,
    String request,
  ) async => await _validationChannel.invokeMethod(name, {"request": request});
}
