/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2024 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import 'package:online_payments_repository/providers/session_state_provider.dart';
import 'package:online_payments_repository/models/result.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_product_state_provider.g.dart';

@Riverpod()
class PaymentProductState extends _$PaymentProductState {
  @override
  Result<PaymentProduct> build() {
    return Result();
  }

  void getPaymentProduct(String? productId) {
    final session = ref.read(sessionStateProvider).session;
    final paymentContext = ref.read(sessionStateProvider).paymentContext;

    final request = PaymentProductRequest(
      paymentContext: paymentContext,
      productId: productId ?? "1",
    );

    final listener = PaymentProductResponseListener(
      onSuccess: _savePaymentProduct,
      onError: _saveErrorResponse,
      onException: _saveNativeException,
    );

    session?.getPaymentProduct(request: request, listener: listener);
  }

  void _savePaymentProduct(PaymentProduct paymentProduct) {
    state = state.copyWith(
      data: paymentProduct,
      errorResponse: null,
      nativeException: null,
    ) as Result<PaymentProduct>;
  }

  void _saveErrorResponse(ErrorResponse? errorResponse) {
    state = state.copyWith(
      data: null,
      errorResponse: errorResponse,
      nativeException: null,
    ) as Result<PaymentProduct>;
  }

  void _saveNativeException(NativeException? nativeException) {
    state = state.copyWith(
      data: null,
      errorResponse: null,
      nativeException: nativeException,
    ) as Result<PaymentProduct>;
  }
}
