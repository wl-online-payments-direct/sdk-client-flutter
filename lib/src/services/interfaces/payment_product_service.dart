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

import '../../domain/payment_context.dart';
import '../../domain/payment_product/basic_payment_products.dart';
import '../../domain/payment_product/payment_product.dart';
import '../../domain/payment_product/payment_product_networks.dart';

abstract class PaymentProductService {
  Future<BasicPaymentProducts> getBasicPaymentProducts(PaymentContext context);

  Future<PaymentProduct> getPaymentProduct(int paymentProductId, PaymentContext context);

  Future<PaymentProductNetworksResponse> getPaymentProductNetworks(int paymentProductId, PaymentContext context);
}
