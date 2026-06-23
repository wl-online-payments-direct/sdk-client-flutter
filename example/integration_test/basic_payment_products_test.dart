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
import 'package:http/http.dart' as http;
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

      expect(result.basicPaymentProducts, isNotEmpty);

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
      final returnedIds = result.basicPaymentProducts.map((product) => product.id).toList();

      for (final unsupportedId in SupportedProductsUtil.sdkUnsupportedProducts) {
        expect(returnedIds, isNot(contains(unsupportedId)));
      }
    });
  });

  group('sdk.getBasicPaymentProducts deterministic HTTP scenarios', () {
    test('getBasicPaymentProducts_FiltersProductsNotSupportedBySdk', () async {
      final client = StubHttpClient((request) async {
        return jsonResponse(
          200,
          _basicProductsResponse([
            _basicPaymentProductJson(1, label: 'Visa', displayOrder: 0),
            for (final id in SupportedProductsUtil.sdkUnsupportedProducts)
              _basicPaymentProductJson(id, label: 'Unsupported $id', displayOrder: id),
          ]),
        );
      });

      final sdk = createSdkWithHttpClient(client);
      addTearDown(sdk.dispose);

      final result = await sdk.getBasicPaymentProducts(TestHelpers.createTestPaymentContext());
      final returnedIds = result.basicPaymentProducts.map((product) => product.id).toList();

      expect(returnedIds, contains(1));

      for (final unsupportedId in SupportedProductsUtil.sdkUnsupportedProducts) {
        expect(returnedIds, isNot(contains(unsupportedId)));
      }
    });

    test('getBasicPaymentProducts_FiltersProductsNotSupportedInThisBrowser', () async {
      final client = StubHttpClient((request) async {
        return jsonResponse(
          200,
          _basicProductsResponse([
            _basicPaymentProductJson(1, label: 'Visa', displayOrder: 0),
            _basicPaymentProductJson(
              SupportedProductsUtil.applePayPaymentProductId,
              label: 'Apple Pay',
              displayOrder: 1,
            ),
          ]),
        );
      });

      final sdk = createSdkWithHttpClient(client);
      addTearDown(sdk.dispose);

      final result = await sdk.getBasicPaymentProducts(TestHelpers.createTestPaymentContext());
      final returnedIds = result.basicPaymentProducts.map((product) => product.id).toList();

      expect(returnedIds, contains(1));
      expect(returnedIds, isNot(contains(SupportedProductsUtil.applePayPaymentProductId)));
    });

    test('getBasicPaymentProducts_WithMalformedJson_ThrowsCommunicationError', () async {
      final client = StubHttpClient((request) async {
        return http.Response(
          '{',
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final sdk = createSdkWithHttpClient(client);
      addTearDown(sdk.dispose);

      await expectLater(
        sdk.getBasicPaymentProducts(TestHelpers.createTestPaymentContext()),
        throwsA(
          isA<CommunicationError>().having(
                (error) => error.statusCode,
            'statusCode',
            equals(200),
          ),
        ),
      );
    });

    test('getBasicPaymentProducts_WithNetworkFailure_ThrowsCommunicationError', () async {
      final sdk = createSdkWithHttpClient(FailingHttpClient());
      addTearDown(sdk.dispose);

      await expectLater(
        sdk.getBasicPaymentProducts(TestHelpers.createTestPaymentContext()),
        throwsA(isA<CommunicationError>()),
      );
    });

    test('getBasicPaymentProducts_WithInvalidAmount_ThrowsResponseError', () async {
      final client = StubHttpClient((request) async {
        expect(request.url.queryParameters['amount'], equals('-1'));

        return jsonResponse(
          400,
          apiErrorResponse(
            statusCode: 400,
            errorCode: '21000120',
            propertyName: 'amount',
            message: 'INVALID_VALUE',
          ),
        );
      });

      final sdk = createSdkWithHttpClient(client);
      addTearDown(sdk.dispose);

      await expectLater(
        sdk.getBasicPaymentProducts(TestHelpers.createTestPaymentContext(amountInCents: -1)),
        throwsA(
          isA<ResponseError>().having(
                (error) => error.statusCode,
            'statusCode',
            equals(400),
          ),
        ),
      );
    });

    test('getBasicPaymentProducts_WhenNoPaymentProductsAreAvailable_ThrowsResponseError', () async {
      final client = StubHttpClient((request) async {
        return jsonResponse(200, _basicProductsResponse([]));
      });

      final sdk = createSdkWithHttpClient(client);
      addTearDown(sdk.dispose);

      await expectLater(
        sdk.getBasicPaymentProducts(TestHelpers.createTestPaymentContext()),
        throwsA(
          isA<ResponseError>().having(
                (error) => error.statusCode,
            'statusCode',
            equals(404),
          ),
        ),
      );
    });

    test('getBasicPaymentProducts_With503Response_ThrowsResponseError', () async {
      final client = StubHttpClient((request) async {
        return jsonResponse(
          503,
          apiErrorResponse(
            statusCode: 503,
            errorCode: '9002',
            message: 'SERVICE_UNAVAILABLE',
          ),
        );
      });

      final sdk = createSdkWithHttpClient(client);
      addTearDown(sdk.dispose);

      await expectLater(
        sdk.getBasicPaymentProducts(TestHelpers.createTestPaymentContext()),
        throwsA(
          isA<ResponseError>().having(
                (error) => error.statusCode,
            'statusCode',
            equals(503),
          ),
        ),
      );
    });
  });
}

Map<String, dynamic> _basicProductsResponse(List<Map<String, dynamic>> paymentProducts) {
  return {
    'paymentProducts': paymentProducts,
  };
}

Map<String, dynamic> _basicPaymentProductJson(
    int id, {
      required String label,
      required int displayOrder,
    }) {
  return {
    'id': id,
    'paymentMethod': 'card',
    'paymentProductGroup': 'cards',
    'allowsRecurring': true,
    'allowsTokenization': true,
    'usesRedirectionTo3rdParty': false,
    'displayHints': {
      'displayOrder': displayOrder,
      'label': label,
      'logo': 'logo-$id.png',
    },
  };
}