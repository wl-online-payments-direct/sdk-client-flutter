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
import 'package:online_payments_repository/models/session_container.dart';
import 'package:online_payments_repository/models/session_input.dart';
import 'package:online_payments_repository/strings.dart' as strings;
import 'package:online_payments_sdk/online_payments_sdk.dart';

class SessionStateNotifier extends StateNotifier<SessionContainer> {
  SessionStateNotifier() : super(SessionContainer(
    paymentContext: PaymentContext(AmountOfMoney(10, "USD"), "US", false),
  ));

  void setSession(SessionInput sessionInput) {
    final session = Session(
      sessionInput.clientSessionId ?? "",
      sessionInput.customerId ?? "",
      sessionInput.clientApiUrl ?? "",
      sessionInput.assetUrl ?? "",
      isEnvironmentProduction: false,
      appIdentifier: strings.appIdentifier,
      loggingEnabled: false,
    );

    state = state.copyWith(session: session);
  }
}

final sessionStateProvider = StateNotifierProvider<SessionStateNotifier, SessionContainer>(
    (ref) => SessionStateNotifier());
