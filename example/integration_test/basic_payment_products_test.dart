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
import 'package:online_payments_sdk/src/infrastructure/utils/supported_products_util.dart';

import 'test_credentials.dart';
import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await TestCredentials.get();
  });

  group('sdk.getBasicPaymentProducts', () {
    late OnlinePaymentSdk sdk;

    setUp(() => sdk = TestHelpers.createSdk());
    tearDown(() => sdk.dispose());

    test('getBasicPaymentProducts_ReturnsProductWithValidStructure', () async {
      final result = await sdk.getBasicPaymentProducts(TestHelpers.createTestPaymentContext());
      final first = result.basicPaymentProducts.first;
      expect(first.id, isA<int?>());
      expect(first.paymentMethod, isA<String>());
    });

    test('getBasicPaymentProducts_CalledTwice_ReturnsCachedResultOnSecondCall', () async {
      final (countingSdk, counter) = createSdkWithCounter();
      addTearDown(countingSdk.dispose);

      await countingSdk.getBasicPaymentProducts(TestHelpers.createTestPaymentContext());
      await countingSdk.getBasicPaymentProducts(TestHelpers.createTestPaymentContext());

      expect(counter.callCount, equals(1));
    });

    test('getBasicPaymentProducts_WithDifferentContext_MakesNewApiCall', () async {
      final (countingSdk, counter) = createSdkWithCounter();
      addTearDown(countingSdk.dispose);

      await countingSdk.getBasicPaymentProducts(TestHelpers.createTestPaymentContext(currencyCode: 'EUR'));
      await countingSdk.getBasicPaymentProducts(TestHelpers.createTestPaymentContext(currencyCode: 'USD'));

      expect(counter.callCount, equals(2));
    });

    test('getBasicPaymentProducts_FiltersSdkUnsupportedProducts', () async {
      final result = await sdk.getBasicPaymentProducts(TestHelpers.createTestPaymentContext());
      final returnedIds = result.basicPaymentProducts.map((p) => p.id).toList();

      for (final unsupportedId in SupportedProductsUtil.sdkUnsupportedProducts) {
        expect(returnedIds, isNot(contains(unsupportedId)));
      }
    });
  });
}
