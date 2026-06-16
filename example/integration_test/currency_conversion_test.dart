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

// TODO: un-skip this test suite once the merchant has been configured to support currency conversion.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await TestCredentials.get();
  });

  group('sdk.getCurrencyConversionQuote', skip: 'Requires merchant configured with currency conversion support', () {
    late OnlinePaymentSdk sdk;

    setUp(() => sdk = TestHelpers.createSdk());
    tearDown(() => sdk.dispose());

    final amountOfMoney = AmountOfMoney(1000, 'AUD');

    test('getCurrencyConversionQuote_WithCardAndProductId_ReturnsProposal', () async {
      final cardSource = CardSourceWithCard(Card(
        const String.fromEnvironment('partialCardNumberWithCurrencyConversion'),
        paymentProductId: int.tryParse(const String.fromEnvironment('productIdWithCurrencyConversion')),
      ));
      final result = await sdk.getCurrencyConversionQuote(amountOfMoney, cardSource);
      expect(result.proposal, isNotNull);
      expect(result.proposal.baseAmount.amount, equals(amountOfMoney.amount));
    });

    test('getCurrencyConversionQuote_WithCardAndNoProductId_ReturnsProposal', () async {
      final cardSource = CardSourceWithCard(Card(
        const String.fromEnvironment('partialCardNumberWithCurrencyConversion'),
      ));
      final result = await sdk.getCurrencyConversionQuote(amountOfMoney, cardSource);
      expect(result.proposal, isNotNull);
      expect(result.proposal.baseAmount.amount, equals(amountOfMoney.amount));
    });

    test('getCurrencyConversionQuote_WithTokenSource_ReturnsProposal', () async {
      const cardSource = CardSourceWithToken(String.fromEnvironment('cardTokenWithCurrencyConversion'));
      final result = await sdk.getCurrencyConversionQuote(amountOfMoney, cardSource);
      expect(result.proposal, isNotNull);
      expect(result.proposal.baseAmount.amount, equals(amountOfMoney.amount));
    });

    test('getCurrencyConversionQuote_WhenCardDoesNotSupportConversion_ThrowsSdkError', () async {
      final cardSource = CardSourceWithCard(Card(
        const String.fromEnvironment('partialCardNumberWithNoCurrencyConversion'),
        paymentProductId: int.tryParse(const String.fromEnvironment('productIdWithNoCurrencyConversion')),
      ));
      await expectLater(
        () => sdk.getCurrencyConversionQuote(amountOfMoney, cardSource),
        throwsA(isA<SdkError>()),
      );
    });

    test('getCurrencyConversionQuote_WhenCardWithoutProductIdDoesNotSupportConversion_ThrowsSdkError', () async {
      final cardSource = CardSourceWithCard(Card(
        const String.fromEnvironment('partialCardNumberWithNoCurrencyConversion'),
      ));
      await expectLater(
        () => sdk.getCurrencyConversionQuote(amountOfMoney, cardSource),
        throwsA(isA<SdkError>()),
      );
    });

    test('getCurrencyConversionQuote_CalledTwiceWithSameParameters_ReturnsCachedResult', () async {
      const cardSource = CardSourceWithToken(String.fromEnvironment('cardTokenWithCurrencyConversion'));
      final (countingSdk, counter) = createSdkWithCounter();
      addTearDown(countingSdk.dispose);
      await countingSdk.getCurrencyConversionQuote(amountOfMoney, cardSource);
      await countingSdk.getCurrencyConversionQuote(amountOfMoney, cardSource);
      expect(counter.callCount, equals(1));
    });
  });
}
