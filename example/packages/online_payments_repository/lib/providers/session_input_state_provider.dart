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
import 'package:online_payments_repository/models/session_input.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_input_state_provider.g.dart';

@Riverpod()
class SessionInputState extends _$SessionInputState {
  @override
  SessionInput build() {
    return const SessionInput();
  }

  void updateAssetUrl(String assetUrl) {
    state = state.copyWith(assetUrl: assetUrl);
  }

  void updateClientApiUrl(String clientApiUrl) {
    state = state.copyWith(clientApiUrl: clientApiUrl);
  }

  void updateClientSessionId(String clientSessionId) {
    state = state.copyWith(clientSessionId: clientSessionId);
  }

  void updateCustomerId(String customerId) {
    state = state.copyWith(customerId: customerId);
  }

  void updatePaymentProductId(String paymentProductId) {
    state = state.copyWith(paymentProductId: paymentProductId);
  }
}
