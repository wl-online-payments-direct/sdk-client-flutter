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

import 'package:integration_test/integration_test.dart';

import 'basic_payment_products_test.dart' as basic_payment_products;
import 'credit_card_token_request_test.dart' as credit_card_token_request;
import 'currency_conversion_test.dart' as currency_conversion;
import 'iin_details_test.dart' as iin_details;
import 'payment_product_networks_test.dart' as payment_product_networks;
import 'payment_product_test.dart' as payment_product;
import 'payment_request_test.dart' as payment_request;
import 'public_key_test.dart' as public_key;
import 'server_api_test.dart' as server_api;
import 'surcharge_calculation_test.dart' as surcharge_calculation;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  public_key.main();
  payment_product.main();
  basic_payment_products.main();
  payment_product_networks.main();
  iin_details.main();
  currency_conversion.main();
  surcharge_calculation.main();
  credit_card_token_request.main();
  payment_request.main();
  server_api.main();
}
