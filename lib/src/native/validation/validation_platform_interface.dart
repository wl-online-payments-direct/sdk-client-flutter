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

abstract class _NativeValidationInterface extends PlatformInterface {
  /// Constructs a OnlinePaymentsSdkFlutterPlatform.
  _NativeValidationInterface() : super(token: _token);

  static final Object _token = Object();

  static final _NativeValidationInterface _channel = _ValidationMethodChannel();

  /// The default instance of [_NativeValidationInterface] to use.
  ///
  /// Defaults to [NativeApiMethodChannel].
  static _NativeValidationInterface get instance => _channel;

  Future<String> validatePaymentRequest(String validationRequest) {
    throw UnimplementedError("Validate has not been implemented");
  }

  Future<String> validatePaymentProductFieldForPaymentRequest(
    String validationRequest,
  ) {
    throw UnimplementedError("Validate has not been implemented");
  }

  Future<String> validateValueForPaymentProductField(String validationRequest) {
    throw UnimplementedError("Validate has not been implemented");
  }

  Future<String> validateValueForValidationRule(String validationRequest) {
    throw UnimplementedError("Validate has not been implemented");
  }

  Future<String> validatePaymentRequestForValidationRule(
    String validationRequest,
  ) {
    throw UnimplementedError("Validate has not been implemented");
  }
}
