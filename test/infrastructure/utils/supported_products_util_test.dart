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
import 'package:online_payments_sdk/src/domain/errors/api_error_item.dart';
import 'package:online_payments_sdk/src/domain/errors/error_response.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/payment_product/basic_payment_products_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/utils/supported_products_util.dart';

const _minimalProductJson = {
  'id': 1,
  'paymentMethod': 'card',
  'displayHints': {'displayOrder': 1, 'label': 'Test', 'logo': 'test'},
  'accountsOnFile': [],
};

void main() {
  group('SupportedProductsUtil', () {
    test('applePayPaymentProductId_Is302', () {
      expect(SupportedProductsUtil.applePayPaymentProductId, equals(302));
    });

    test('isSupportedInSdk_WhenProductNotInUnsupportedList_ReturnsTrue', () {
      expect(SupportedProductsUtil.isSupportedInSdk(1), isTrue);
      expect(SupportedProductsUtil.isSupportedInSdk(2), isTrue);
    });

    test('isSupportedInSdk_WhenProductIsApplePay_ReturnsTrue', () {
      expect(SupportedProductsUtil.isSupportedInSdk(302), isTrue);
    });

    test('isSupportedInSdk_WhenKnownUnsupportedProductId_ReturnsFalse', () {
      expect(SupportedProductsUtil.isSupportedInSdk(117), isFalse);
      expect(SupportedProductsUtil.isSupportedInSdk(5700), isFalse);
      expect(SupportedProductsUtil.isSupportedInSdk(5772), isFalse);
      expect(SupportedProductsUtil.isSupportedInSdk(5784), isFalse);
    });

    test('filterOutSdkUnsupportedProducts_WhenDtoContainsUnsupportedProducts_RemovesThem', () {
      final dto = BasicPaymentProductsDto.fromJson({
        'paymentProducts': [
          _minimalProductJson,
          {
            'id': 117,
            'paymentMethod': 'card',
            'displayHints': {'displayOrder': 2, 'label': 'Maestro', 'logo': 'maestro'},
            'accountsOnFile': [],
          },
        ],
      });

      SupportedProductsUtil.filterOutSdkUnsupportedProducts(dto);

      expect(dto.paymentProducts, hasLength(1));
      expect(dto.paymentProducts.first.id, equals(1));
    });

    test('filterOutSdkUnsupportedProducts_DoesNotRemoveApplePay', () {
      final dto = BasicPaymentProductsDto.fromJson({
        'paymentProducts': [
          {
            'id': 302,
            'paymentMethod': 'card',
            'displayHints': {'displayOrder': 1, 'label': 'Apple Pay', 'logo': 'applepay'},
            'accountsOnFile': [],
          },
        ],
      });

      SupportedProductsUtil.filterOutSdkUnsupportedProducts(dto);

      expect(dto.paymentProducts, hasLength(1));
      expect(dto.paymentProducts.first.id, equals(302));
    });

    test('get404Error_ReturnsErrorResponseWithExpectedProperties', () {
      final error = SupportedProductsUtil.get404Error();

      expect(error, isA<ErrorResponse>());
      expect(error.errors, hasLength(1));
      final item = error.errors.first.errors!.first;
      expect(item, isA<ApiErrorItem>());
      expect(item.errorCode, equals('1007'));
      expect(item.propertyName, equals('productId'));
      expect(item.httpStatusCode, equals(404));
    });
  });
}
