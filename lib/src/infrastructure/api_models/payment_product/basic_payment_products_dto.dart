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
import 'basic_payment_product_dto.dart';

class BasicPaymentProductsDto {
  List<BasicPaymentProductDto> paymentProducts;

  BasicPaymentProductsDto({List<BasicPaymentProductDto>? paymentProducts}) : paymentProducts = paymentProducts ?? [];

  factory BasicPaymentProductsDto.fromJson(Map<String, dynamic> json) => BasicPaymentProductsDto(
        paymentProducts: (json['paymentProducts'] as List<dynamic>? ?? [])
            .map((e) => BasicPaymentProductDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
