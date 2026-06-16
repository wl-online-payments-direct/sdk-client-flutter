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

  group('sdk.getPaymentProduct', () {
    late OnlinePaymentSdk sdk;

    setUp(() => sdk = TestHelpers.createSdk());
    tearDown(() => sdk.dispose());

    test('getPaymentProduct_WhenProductDoesNotExist_ThrowsSdkError', () async {
      await expectLater(
        () => sdk.getPaymentProduct(99999, TestHelpers.createTestPaymentContext()),
        throwsA(isA<SdkError>()),
      );
    });

    test('getPaymentProduct_ReturnsProductWithValidFieldStructure', () async {
      final product = await sdk.getPaymentProduct(1, TestHelpers.createTestPaymentContext());
      expect(product.fields, isA<List<PaymentProductField>>());
      if (product.fields.isNotEmpty) {
        final first = product.fields.first;
        expect(first.id, isA<String>());
        expect(first.type, isA<PaymentProductFieldType>());
        expect(first.displayHints, isA<ProductFieldDisplayHints?>());
        expect(first.dataRestrictions, isA<DataRestrictions>());
      }
    });

    test('getPaymentProduct_ReturnsProductWithDisplayHints', () async {
      final product = await sdk.getPaymentProduct(1, TestHelpers.createTestPaymentContext());

      expect(product.logo, isNotNull);
      expect(product.logo, isNotEmpty);
    });

    test('getPaymentProduct_ReturnsProductWithPaymentProductFields', () async {
      final product = await sdk.getPaymentProduct(1, TestHelpers.createTestPaymentContext());

      expect(product.fields, isNotEmpty);
      expect(product.fields.any((f) => f.id == 'cardNumber'), isTrue);
    });

    test('getPaymentProduct_CalledTwice_ReturnsCachedResultOnSecondCall', () async {
      final (countingSdk, counter) = createSdkWithCounter();
      addTearDown(countingSdk.dispose);

      await countingSdk.getPaymentProduct(1, TestHelpers.createTestPaymentContext());
      await countingSdk.getPaymentProduct(1, TestHelpers.createTestPaymentContext());

      expect(counter.callCount, equals(1));
    });

    test('getPaymentProduct_WhenUnsupportedSdkProductId_ThrowsResponseErrorWith404', () async {
      for (final id in SupportedProductsUtil.sdkUnsupportedProducts) {
        try {
          await sdk.getPaymentProduct(id, TestHelpers.createTestPaymentContext());
          fail('Should have thrown for product id $id');
        } catch (error) {
          expect(error, isA<ResponseError>(), reason: 'Expected ResponseError for id $id');
          final responseError = error as ResponseError;
          expect(responseError.apiError?.errors?.first.errorCode, equals('1007'));
          expect(responseError.apiError?.errors?.first.propertyName, equals('productId'));
        }
      }
    });

    test('getPaymentProduct_ReturnsProductWithMappedAccountsOnFile', () async {
      final product = await sdk.getPaymentProduct(1, TestHelpers.createTestPaymentContext());

      expect(product.accountsOnFile, isA<List<AccountOnFile>>());
    });
  });
}
