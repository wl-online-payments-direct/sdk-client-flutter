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

import '../../domain/card/card_source.dart';
import '../../domain/amount_of_money.dart';
import '../../domain/currency_conversion/currency_conversion_response.dart';
import '../../domain/iin/iin_details_response.dart';
import '../../domain/payment_context.dart';
import '../../domain/surcharge_calculation/surcharge_calculation_response.dart';

abstract class ClientService {
  Future<IinDetailsResponse> getIinDetails(String partialCreditCardNumber, PaymentContext context);

  Future<CurrencyConversionResponse> getCurrencyConversionQuote(AmountOfMoney amountOfMoney, CardSource cardSource);

  Future<SurchargeCalculationResponse> getSurchargeCalculation(AmountOfMoney amountOfMoney, CardSource cardSource);
}
