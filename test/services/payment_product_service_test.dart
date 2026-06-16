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
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/infrastructure/factories/default_payment_product_factory.dart';
import 'package:online_payments_sdk/src/infrastructure/utils/cache_manager.dart';
import 'package:online_payments_sdk/src/infrastructure/utils/supported_products_util.dart';
import 'package:online_payments_sdk/src/services/default_payment_product_service.dart';

import '../helpers/test_api_client.dart';
import '../helpers/test_utils.dart';

class _TestApplePay implements ApplePay {
  final bool isAvailable;

  const _TestApplePay(this.isAvailable);

  @override
  Future<bool> isApplePayAvailable() async => isAvailable;
}

void main() {
  late TestApiClient apiClient;
  late DefaultPaymentProductService service;
  final paymentContext = PaymentContext(AmountOfMoney(100, 'EUR'), 'NL', isRecurring: true);

  setUp(() {
    apiClient = TestApiClient();
    service = DefaultPaymentProductService(
      CacheManager(),
      apiClient,
      DefaultPaymentProductFactory(),
      const _TestApplePay(false),
    );
  });

  group('DefaultPaymentProductService.getBasicPaymentProducts', () {
    test('returns products from cache on subsequent calls', () async {
      var callCount = 0;
      apiClient.setMockGetWithContext((_) async {
        callCount++;
        return successResponse(loadBasicPaymentProductsFixtureJson());
      });

      final first = await service.getBasicPaymentProducts(paymentContext);
      final second = await service.getBasicPaymentProducts(paymentContext);

      expect(callCount, 1);
      expect(first.basicPaymentProducts.length, 2);
      expect(second.basicPaymentProducts.length, 2);
    });

    test('filters out Apple Pay when unavailable', () async {
      apiClient.setMockGetWithContext(
        (_) async => successResponse(loadBasicPaymentProductsFixtureJson()),
      );

      final result = await service.getBasicPaymentProducts(paymentContext);
      final ids = result.basicPaymentProducts.map((product) => product.id).toList();

      expect(ids, isNot(contains(SupportedProductsUtil.applePayPaymentProductId)));
      expect(ids, contains(2));
      expect(ids, contains(3012));
    });

    test('keeps Apple Pay when available', () async {
      service = DefaultPaymentProductService(
        CacheManager(),
        apiClient,
        DefaultPaymentProductFactory(),
        const _TestApplePay(true),
      );
      apiClient.setMockGetWithContext(
        (_) async => successResponse(loadBasicPaymentProductsFixtureJson()),
      );

      final result = await service.getBasicPaymentProducts(paymentContext);
      final ids = result.basicPaymentProducts.map((product) => product.id).toList();

      expect(ids, contains(SupportedProductsUtil.applePayPaymentProductId));
    });

    test('throws a ResponseError on an unsuccessful response', () {
      apiClient.setMockGetWithContext(
        (_) async => errorResponse({
          'errorId': 'error-id',
          'errors': [
            {
              'errorCode': '50001130',
              'category': 'PAYMENT_PLATFORM_ERROR',
              'code': '50001130',
              'httpStatusCode': 404,
              'id': 'UNKNOWN_PAYMENT_ID',
              'message': 'Authorisation declined',
              'propertyName': 'paymentId',
              'retriable': true,
            },
          ],
        }),
      );

      expect(
        service.getBasicPaymentProducts(paymentContext),
        throwsA(
          isA<ResponseError>().having(
            (error) => error.message,
            'message',
            'Error while trying to fetch basic payment products.',
          ),
        ),
      );
    });

    test('getBasicPaymentProducts_WhenAllProductsFilteredOut_ThrowsResponseError', () {
      apiClient.setMockGetWithContext((_) async => successResponse({
            'paymentProducts': [
              {
                'id': 117, // maestro — SDK unsupported
                'paymentMethod': 'card',
                'displayHints': {'displayOrder': 1, 'label': 'Maestro', 'logo': 'maestro'},
                'accountsOnFile': [],
              },
              {
                'id': 5700, // intersolve — SDK unsupported
                'paymentMethod': 'card',
                'displayHints': {'displayOrder': 2, 'label': 'Intersolve', 'logo': 'intersolve'},
                'accountsOnFile': [],
              },
            ],
          }));

      expect(
        service.getBasicPaymentProducts(paymentContext),
        throwsA(
          isA<ResponseError>()
              .having((error) => error.message, 'message', 'No payment products available')
              .having((error) => error.statusCode, 'statusCode', 404)
              .having((error) => error.apiError?.errors?.first.errorCode, 'errorCode', '1007')
              .having((error) => error.apiError?.errors?.first.propertyName, 'propertyName', 'productId'),
        ),
      );
    });
  });

  group('DefaultPaymentProductService.getPaymentProductNetworks', () {
    test('returns networks from cache on subsequent calls', () async {
      var callCount = 0;
      apiClient.setMockGetWithContext((_) async {
        callCount++;
        return successResponse(loadFixture('payment_product_networks_response.json'));
      });

      final first = await service.getPaymentProductNetworks(1, paymentContext);
      final second = await service.getPaymentProductNetworks(1, paymentContext);

      expect(callCount, 1);
      expect(first.networks, contains('VISA'));
      expect(second.networks, contains('VISA'));
    });

    test('getPaymentProductNetworks_WhenApiCacheMiss_CallsApiAndReturnsResult', () async {
      var callCount = 0;
      apiClient.setMockGetWithContext((_) async {
        callCount++;

        return successResponse(loadFixture('payment_product_networks_response.json'));
      });

      final result = await service.getPaymentProductNetworks(1, paymentContext);

      expect(callCount, equals(1));
      expect(result, isA<PaymentProductNetworksResponse>());
      expect(result.networks, isNotEmpty);
    });

    test('getPaymentProductNetworks_WhenApiResponseIsInvalid_ThrowsResponseError', () {
      apiClient.setMockGetWithContext((_) async => errorResponse({}));

      expect(
        service.getPaymentProductNetworks(1, paymentContext),
        throwsA(
          isA<ResponseError>().having(
            (error) => error.message,
            'message',
            'Error while trying to fetch payment product networks for product with id 1.',
          ),
        ),
      );
    });
  });

  group('DefaultPaymentProductService.getPaymentProduct', () {
    test('returns payment products from cache on subsequent calls', () async {
      var callCount = 0;
      apiClient.setMockGetWithContext((_) async {
        callCount++;
        return successResponse(loadPaymentProductFixtureJson());
      });

      final first = await service.getPaymentProduct(3, paymentContext);
      final second = await service.getPaymentProduct(3, paymentContext);

      expect(callCount, 1);
      expect(first.id, 3);
      expect(second.id, 3);
    });

    test('throws when a product is not supported in the SDK', () {
      expect(
        service.getPaymentProduct(117, paymentContext),
        throwsA(
          isA<ResponseError>()
              .having((error) => error.message, 'message', 'Product not found or not available.')
              .having((error) => error.apiError?.errors?.first.errorCode, 'errorCode', '1007')
              .having((error) => error.apiError?.errors?.first.propertyName, 'propertyName', 'productId'),
        ),
      );
    });

    test('throws when Apple Pay is requested but unavailable', () {
      expect(
        service.getPaymentProduct(SupportedProductsUtil.applePayPaymentProductId, paymentContext),
        throwsA(
          isA<ResponseError>()
              .having((error) => error.message, 'message', 'Product not found or not available.')
              .having((error) => error.apiError?.errors?.first.errorCode, 'errorCode', '1007')
              .having((error) => error.apiError?.errors?.first.propertyName, 'propertyName', 'productId'),
        ),
      );
    });

    test('returns Apple Pay when available', () async {
      service = DefaultPaymentProductService(
        CacheManager(),
        apiClient,
        DefaultPaymentProductFactory(),
        const _TestApplePay(true),
      );
      apiClient.setMockGetWithContext((_) async => successResponse(loadPaymentProductFixtureJson()));

      final result = await service.getPaymentProduct(SupportedProductsUtil.applePayPaymentProductId, paymentContext);

      expect(result, isA<PaymentProduct>());
    });

    test('getPaymentProduct_WhenCacheMiss_CallsApiAndStoresInCache', () async {
      var callCount = 0;
      apiClient.setMockGetWithContext((_) async {
        callCount++;

        return successResponse(loadPaymentProductFixtureJson());
      });

      final result = await service.getPaymentProduct(3, paymentContext);

      expect(callCount, equals(1));
      expect(result, isA<PaymentProduct>());
      expect(result.id, equals(3));

      final cachedResult = await service.getPaymentProduct(3, paymentContext);
      expect(callCount, equals(1));
      expect(cachedResult, same(result));
    });

    test('getPaymentProduct_WhenApiResponseIsInvalid_ThrowsResponseError', () {
      apiClient.setMockGetWithContext((_) async => errorResponse({}));

      expect(
        service.getPaymentProduct(3, paymentContext),
        throwsA(
          isA<ResponseError>()
              .having((error) => error.message, 'message', 'Error while trying to fetch the payment product 3.'),
        ),
      );
    });
  });
}
