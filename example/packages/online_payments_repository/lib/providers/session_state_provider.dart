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
import 'package:online_payments_repository/models/session_container.dart';
import 'package:online_payments_repository/models/session_input.dart';
import 'package:online_payments_repository/strings.dart' as strings;
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_state_provider.g.dart';

@Riverpod(keepAlive: true)
class SessionState extends _$SessionState {
  @override
  SessionContainer build() {
    // Since this is only a simple example, the PaymentContext is hardcoded. Please refer to the full example (see the link in the README) if you want to enter your own Payment Context values.
    return SessionContainer(
      paymentContext: PaymentContext(AmountOfMoney(10, "USD"), "US", false),
    );
  }

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
