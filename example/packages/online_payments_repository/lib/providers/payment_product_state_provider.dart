/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2026 Worldline and/or its affiliates.
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

  Future<void> getPaymentProduct(String? productId) async {
    final sessionContainer = _ref.read(sessionStateProvider);
    final sdk = sessionContainer.sdk;
    final paymentContext = sessionContainer.paymentContext;

    final id = int.tryParse(productId ?? "1") ?? 1;

    try {
      final product = await sdk!.getPaymentProduct(id, paymentContext);
      state = state.copyWith(data: product, error: null);
    } on SdkError catch (e) {
      state = state.copyWith(data: null, error: e);
    }
  }
}

final paymentProductStateProvider = StateNotifierProvider<PaymentProductStateNotifier, Result<PaymentProduct>>(
    (ref) => PaymentProductStateNotifier(ref));
