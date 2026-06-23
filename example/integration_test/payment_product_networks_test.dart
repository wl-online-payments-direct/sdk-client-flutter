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

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

import 'test_credentials.dart';
import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await TestCredentials.get();
  });

  group('sdk.getPaymentProductNetworks', () {
    late OnlinePaymentSdk sdk;

    // Google Pay product ID that supports networks
    const googlePayId = 320;

    setUp(() => sdk = TestHelpers.createSdk());
    tearDown(() => sdk.dispose());

    test('getPaymentProductNetworks_ForGooglePay_ReturnsNetworks', () async {
      final result = await sdk.getPaymentProductNetworks(googlePayId, TestHelpers.createTestPaymentContext());

      expect(result, isA<PaymentProductNetworksResponse>());
      expect(result.networks, isNotEmpty);
    });

    test('getPaymentProductNetworks_WithUnsupportedProduct_ThrowsSdkError', () async {
      await expectLater(
            () => sdk.getPaymentProductNetworks(1, TestHelpers.createTestPaymentContext()),
        throwsA(isA<SdkError>()),
      );
    });

    test('getPaymentProductNetworks_CalledTwice_ReturnsCachedResultOnSecondCall', () async {
      final (countingSdk, counter) = createSdkWithCounter();
      addTearDown(countingSdk.dispose);

      await countingSdk.getPaymentProductNetworks(googlePayId, TestHelpers.createTestPaymentContext());
      await countingSdk.getPaymentProductNetworks(googlePayId, TestHelpers.createTestPaymentContext());

      expect(counter.callCount, equals(1));
    });

    test('getPaymentProductNetworks_WithDifferentContext_MakesNewApiCall', () async {
      final (countingSdk, counter) = createSdkWithCounter();
      addTearDown(countingSdk.dispose);

      await countingSdk.getPaymentProductNetworks(
        googlePayId,
        TestHelpers.createTestPaymentContext(amountInCents: 1000),
      );

      await countingSdk.getPaymentProductNetworks(
        googlePayId,
        TestHelpers.createTestPaymentContext(amountInCents: 2000),
      );

      expect(counter.callCount, equals(2));
    });
  });
}