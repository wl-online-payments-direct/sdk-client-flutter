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

// TODO: un-skip this test suite once the merchant has been configured to support surcharge.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await TestCredentials.get();
  });

  group('sdk.getSurchargeCalculation', skip: 'Requires merchant configured with surcharge support', () {
    late OnlinePaymentSdk sdk;

    setUp(() => sdk = TestHelpers.createSdk());
    tearDown(() => sdk.dispose());

    final amountOfMoney = AmountOfMoney(1000, 'EUR');

    test('getSurchargeCalculation_WithCardAndProductId_ReturnsSurchargeResult', () async {
      final cardSource = CardSourceWithCard(Card(
        const String.fromEnvironment('partialCardNumberWithSurcharge'),
        paymentProductId: int.tryParse(const String.fromEnvironment('productIdWithSurcharge')),
      ));
      final result = await sdk.getSurchargeCalculation(amountOfMoney, cardSource);
      expect(result.surcharges, isNotEmpty);
    });

    test('getSurchargeCalculation_WithCardAndNoProductId_ReturnsSurchargeResult', () async {
      final cardSource = CardSourceWithCard(Card(const String.fromEnvironment('partialCardNumberWithSurcharge')));
      final result = await sdk.getSurchargeCalculation(amountOfMoney, cardSource);
      expect(result.surcharges, isNotEmpty);
    });

    test('getSurchargeCalculation_WithTokenSource_ReturnsSurchargeResult', () async {
      const cardSource = CardSourceWithToken(String.fromEnvironment('cardTokenWithSurcharge'));
      final result = await sdk.getSurchargeCalculation(amountOfMoney, cardSource);
      expect(result.surcharges, isNotEmpty);
    });

    test('getSurchargeCalculation_WithNoSurchargeCard_ReturnsSurchargesEmpty', () async {
      final cardSource = CardSourceWithCard(Card(
        const String.fromEnvironment('partialCardNumberWithNoSurcharge'),
        paymentProductId: int.tryParse(const String.fromEnvironment('productIdWithNoSurcharge')),
      ));
      final result = await sdk.getSurchargeCalculation(amountOfMoney, cardSource);
      expect(result.surcharges, isEmpty);
    });

    test('getSurchargeCalculation_WithNoSurchargeCard_WithoutProductId_ReturnsSurchargesEmpty', () async {
      final cardSource = CardSourceWithCard(Card(const String.fromEnvironment('partialCardNumberWithNoSurcharge')));
      final result = await sdk.getSurchargeCalculation(amountOfMoney, cardSource);
      expect(result.surcharges, isEmpty);
    });

    test('getSurchargeCalculation_CalledTwiceWithSameParameters_ReturnsCachedResult', () async {
      const cardSource = CardSourceWithToken(String.fromEnvironment('cardTokenWithSurcharge'));
      final (countingSdk, counter) = createSdkWithCounter();
      addTearDown(countingSdk.dispose);
      await countingSdk.getSurchargeCalculation(amountOfMoney, cardSource);
      await countingSdk.getSurchargeCalculation(amountOfMoney, cardSource);
      expect(counter.callCount, equals(1));
    });
  });
}
