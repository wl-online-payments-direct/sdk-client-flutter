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

import '../../domain/errors/api_error.dart';
import '../../domain/errors/api_error_item.dart';
import '../../domain/errors/error_response.dart';
import '../api_models/payment_product/basic_payment_products_dto.dart';

const _applePayPaymentProductId = 302;
const _maestroPaymentProductId = 117;
const _intersolvePaymentProductId = 5700;
const _sodexoSportAndCulturePaymentProductId = 5772;
const _vvvGiftCardPaymentProductId = 5784;

/// Utility class for filtering SDK-unsupported payment products.
class SupportedProductsUtil {
  SupportedProductsUtil._();

  static const int applePayPaymentProductId = _applePayPaymentProductId;

  static const List<int> sdkUnsupportedProducts = [
    _maestroPaymentProductId,
    _intersolvePaymentProductId,
    _sodexoSportAndCulturePaymentProductId,
    _vvvGiftCardPaymentProductId,
  ];

  static bool isSupportedInSdk(int? id) => id != null && !sdkUnsupportedProducts.contains(id);

  static void filterOutSdkUnsupportedProducts(BasicPaymentProductsDto dto) {
    dto.paymentProducts = dto.paymentProducts.where((p) => isSupportedInSdk(p.id)).toList();
  }

  static ErrorResponse get404Error() => ErrorResponse(
        errorId: '48b78d2d-1b35-4f8b-92cb-57cc2638e901',
        errors: [
          ApiError(
            '48b78d2d-1b35-4f8b-92cb-57cc2638e901',
            errors: [
              ApiErrorItem(
                errorCode: '1007',
                propertyName: 'productId',
                message: 'UNKNOWN_PRODUCT_ID',
                httpStatusCode: 404,
              ),
            ],
          ),
        ],
      );
}
