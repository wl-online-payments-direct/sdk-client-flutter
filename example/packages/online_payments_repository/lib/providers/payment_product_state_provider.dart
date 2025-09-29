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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:online_payments_repository/providers/session_state_provider.dart';
import 'package:online_payments_repository/models/result.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

class PaymentProductStateNotifier extends StateNotifier<Result<PaymentProduct>> {
  PaymentProductStateNotifier(this._ref) : super(Result<PaymentProduct>());

  final Ref _ref;

  void getPaymentProduct(String? productId) {
    final sessionContainer = _ref.read(sessionStateProvider);
    final session = sessionContainer.session;
    final paymentContext = sessionContainer.paymentContext;

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
    );
  }

  void _saveErrorResponse(ErrorResponse? errorResponse) {
    state = state.copyWith(
      data: null,
      errorResponse: errorResponse,
      nativeException: null,
    );
  }

  void _saveNativeException(NativeException? nativeException) {
    state = state.copyWith(
      data: null,
      errorResponse: null,
      nativeException: nativeException,
    );
  }
}

final paymentProductStateProvider = StateNotifierProvider<PaymentProductStateNotifier, Result<PaymentProduct>>(
    (ref) => PaymentProductStateNotifier(ref));
