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

import '../domain/errors/response_error.dart';
import '../domain/payment_context.dart';
import '../domain/payment_product/basic_payment_products.dart';
import '../domain/payment_product/payment_product.dart';
import '../domain/payment_product/payment_product_networks.dart';
import '../infrastructure/api_models/payment_product/basic_payment_products_dto.dart';
import '../infrastructure/api_models/payment_product/payment_product_dto.dart';
import '../infrastructure/interfaces/payment_product_factory.dart';
import '../infrastructure/utils/supported_products_util.dart';
import 'base_service.dart';
import 'interfaces/payment_product_service.dart';
import 'models/apple_pay.dart';

class DefaultPaymentProductService extends BaseService implements PaymentProductService {
  final PaymentProductFactory _paymentProductFactory;
  final ApplePay _applePay;

  DefaultPaymentProductService(
    super.cacheManager,
    super.apiClient,
    this._paymentProductFactory,
    this._applePay,
  );

  @override
  Future<BasicPaymentProducts> getBasicPaymentProducts(PaymentContext context) async {
    final cacheKey = cacheManager.createCacheKeyFromContext(prefix: 'basicPaymentProducts', context: context);

    if (cacheManager.has(cacheKey)) {
      return cacheManager.get<BasicPaymentProducts>(cacheKey)!;
    }

    final response = await apiClient.getWithContext(
      'products',
      queryParams: {..._contextToQueryParams(context), 'hide': 'fields'},
      useCacheBuster: true,
    );

    validateResponse(response, 'Error while trying to fetch basic payment products.');

    final dto = BasicPaymentProductsDto.fromJson(response.data);

    SupportedProductsUtil.filterOutSdkUnsupportedProducts(dto);

    if (!(await _applePay.isApplePayAvailable())) {
      dto.paymentProducts = dto.paymentProducts
          .where((p) => p.id != SupportedProductsUtil.applePayPaymentProductId)
          .toList();
    }

    if (dto.paymentProducts.isEmpty) {
      throw ResponseError(
        'No payment products available',
        statusCode: 404,
        apiError: SupportedProductsUtil.get404Error().errors.firstOrNull,
      );
    }

    final products = _paymentProductFactory.createBasicPaymentProducts(dto);
    cacheManager.set(cacheKey, products);

    return products;
  }

  @override
  Future<PaymentProduct> getPaymentProduct(int paymentProductId, PaymentContext context) async {
    if (!SupportedProductsUtil.isSupportedInSdk(paymentProductId)) {
      throw ResponseError(
        'Product not found or not available.',
        statusCode: 404,
        apiError: SupportedProductsUtil.get404Error().errors.firstOrNull,
      );
    }

    if (paymentProductId == SupportedProductsUtil.applePayPaymentProductId && !(await _applePay.isApplePayAvailable())) {
      throw ResponseError(
        'Product not found or not available.',
        statusCode: 404,
        apiError: SupportedProductsUtil.get404Error().errors.firstOrNull,
      );
    }

    final cacheKey =
        cacheManager.createCacheKeyFromContext(prefix: 'paymentProduct-$paymentProductId', context: context);

    if (cacheManager.has(cacheKey)) {
      return cacheManager.get<PaymentProduct>(cacheKey)!;
    }

    final response = await apiClient.getWithContext(
      'products/$paymentProductId',
      queryParams: {..._contextToQueryParams(context), '_': _cacheBuster()},
    );

    validateResponse(response, 'Error while trying to fetch the payment product $paymentProductId.');

    final product = _paymentProductFactory.createPaymentProduct(PaymentProductDto.fromJson(response.data));
    cacheManager.set(cacheKey, product);

    return product;
  }

  @override
  Future<PaymentProductNetworksResponse> getPaymentProductNetworks(int paymentProductId, PaymentContext context) async {
    final cacheKey = cacheManager.createCacheKeyFromContext(
      prefix: 'paymentProductNetworks-$paymentProductId',
      context: context,
    );

    if (cacheManager.has(cacheKey)) {
      return cacheManager.get<PaymentProductNetworksResponse>(cacheKey)!;
    }

    final response = await apiClient.getWithContext(
      'products/$paymentProductId/networks',
      queryParams: {..._contextToQueryParams(context), '_': _cacheBuster()},
    );

    validateResponse(
      response,
      'Error while trying to fetch payment product networks for product with id $paymentProductId.',
    );

    final networks = PaymentProductNetworksResponse.fromJson(response.data);
    cacheManager.set(cacheKey, networks);

    return networks;
  }

  static Map<String, String> _contextToQueryParams(PaymentContext context) => {
        'countryCode': context.countryCode,
        'isRecurring': context.isRecurring.toString(),
        'amount': context.amountOfMoney.amount.toString(),
        'currencyCode': context.amountOfMoney.currencyCode,
      };

  static String _cacheBuster() => DateTime.now().millisecondsSinceEpoch.toString();
}
