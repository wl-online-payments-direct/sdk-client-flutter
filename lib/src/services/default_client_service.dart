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

import 'dart:convert';

import '../domain/amount_of_money.dart';
import '../domain/card/card_source.dart';
import '../domain/currency_conversion/currency_conversion_response.dart';
import '../domain/errors/invalid_argument_error.dart';
import '../domain/iin/iin_detail.dart';
import '../domain/iin/iin_details_request.dart';
import '../domain/iin/iin_details_response.dart';
import '../domain/iin/iin_status.dart';
import '../domain/payment_context.dart';
import '../domain/surcharge_calculation/surcharge_calculation_response.dart';
import '../infrastructure/models/api_version.dart';
import 'base_service.dart';
import 'interfaces/client_service.dart';

class DefaultClientService extends BaseService implements ClientService {
  DefaultClientService(super.cacheManager, super.apiClient);

  @override
  Future<IinDetailsResponse> getIinDetails(String partialCreditCardNumber, PaymentContext context) async {
    final cacheKey = 'getIinDetails-$partialCreditCardNumber';

    if (cacheManager.has(cacheKey)) {
      return cacheManager.get<IinDetailsResponse>(cacheKey)!;
    }

    final number = _formatPartialCreditCardNumber(partialCreditCardNumber);

    if (number.length < 6) {
      throw InvalidArgumentError(
        'Not enough digits in the credit card number. Minimum 6 digits required.',
        metadata: IinDetailsResponse(IinStatus.notEnoughDigits),
      );
    }

    final requestBody = IinDetailsRequest(number, paymentContext: context);
    final body = jsonEncode({
      'bin': requestBody.bin,
      if (requestBody.paymentContext != null)
        'paymentContext': {
          'amountOfMoney': {
            'amount': requestBody.paymentContext!.amountOfMoney.amount,
            'currencyCode': requestBody.paymentContext!.amountOfMoney.currencyCode,
          },
          'countryCode': requestBody.paymentContext!.countryCode,
          'isRecurring': requestBody.paymentContext!.isRecurring,
        },
    });

    final response = await apiClient.post('services/getIINdetails', body: body);

    if (!response.success) {
      return IinDetailsResponse(IinStatus.unknown);
    }

    validateResponse(response, 'Error while trying to fetch IinDetails.');

    final dto = response.data;
    final isAllowedInContext = dto['isAllowedInContext'] as bool?;
    final iinDetailsResponse = IinDetailsResponse(
      isAllowedInContext != false ? IinStatus.supported : IinStatus.existingButNotAllowed,
      countryCode: dto['countryCode'] as String?,
      paymentProductId: dto['paymentProductId'] != null ? (dto['paymentProductId'] as num).toInt() : null,
      isAllowedInContext: isAllowedInContext,
      coBrands: (dto['coBrands'] as List<dynamic>? ?? [])
          .map((e) => IinDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    cacheManager.set(cacheKey, iinDetailsResponse);

    return iinDetailsResponse;
  }

  @override
  Future<SurchargeCalculationResponse> getSurchargeCalculation(
    AmountOfMoney amountOfMoney,
    CardSource cardSource,
  ) async {
    final suffix = _getCacheKeySuffix(cardSource);
    final cacheKey = 'getSurchargeCalculation-${amountOfMoney.amount}-${amountOfMoney.currencyCode}-$suffix';

    if (cacheManager.has(cacheKey)) {
      return cacheManager.get<SurchargeCalculationResponse>(cacheKey)!;
    }

    final body = jsonEncode({
      'cardSource': _cardSourceToJson(cardSource),
      'amountOfMoney': {'amount': amountOfMoney.amount, 'currencyCode': amountOfMoney.currencyCode},
    });

    final response = await apiClient.post('services/surchargeCalculation', body: body);
    validateResponse(response, 'Error while trying to fetch surcharge calculations.');

    final result = SurchargeCalculationResponse.fromJson(response.data);
    cacheManager.set(cacheKey, result);

    return result;
  }

  @override
  Future<CurrencyConversionResponse> getCurrencyConversionQuote(
    AmountOfMoney amountOfMoney,
    CardSource cardSource,
  ) async {
    final suffix = _getCacheKeySuffix(cardSource);
    final cacheKey = 'getCurrencyConversionQuote-${amountOfMoney.amount}-${amountOfMoney.currencyCode}-$suffix';

    if (cacheManager.has(cacheKey)) {
      return cacheManager.get<CurrencyConversionResponse>(cacheKey)!;
    }

    final body = jsonEncode({
      'cardSource': _cardSourceToJson(cardSource),
      'transaction': {
        'amount': {'amount': amountOfMoney.amount, 'currencyCode': amountOfMoney.currencyCode},
      },
    });

    final response = await apiClient.post('services/dccrate', body: body, apiVersion: ApiVersion.v2);
    validateResponse(response, 'Error while trying to fetch currency conversion.');

    final result = CurrencyConversionResponse.fromJson(response.data);
    cacheManager.set(cacheKey, result);

    return result;
  }

  static String _getCacheKeySuffix(CardSource source) {
    if (source is CardSourceWithCard) return source.card.cardNumber;

    return (source as CardSourceWithToken).token;
  }

  static String _formatPartialCreditCardNumber(String number) {
    final stripped = number.replaceAll(RegExp(r'\s'), '');

    return stripped.length >= 8 ? stripped.substring(0, 8) : stripped.substring(0, stripped.length.clamp(0, 6));
  }

  static Map<String, dynamic> _cardSourceToJson(CardSource source) {
    if (source is CardSourceWithCard) {
      return {
        'card': {
          'cardNumber': source.card.cardNumber,
          if (source.card.paymentProductId != null) 'paymentProductId': source.card.paymentProductId,
        },
      };
    }

    source as CardSourceWithToken;

    return {'token': source.token};
  }
}
