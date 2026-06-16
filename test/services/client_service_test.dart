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

import 'package:flutter_test/flutter_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/infrastructure/utils/cache_manager.dart';
import 'package:online_payments_sdk/src/services/default_client_service.dart';

import '../helpers/test_api_client.dart';
import '../helpers/test_utils.dart';

final _paymentContext = PaymentContext(AmountOfMoney(1000, 'EUR'), 'NL');
final _amountOfMoney = AmountOfMoney(1000, 'EUR');
final _cardSource = CardSourceWithCard(Card('123456789', paymentProductId: 1));

const _iinDetailsJson = {
  'isAllowedInContext': true,
  'countryCode': 'NL',
  'paymentProductId': 1,
  'coBrands': [],
};

const _surchargeJson = {
  'surcharges': [
    {
      'paymentProductId': 1,
      'result': 'OK',
      'netAmount': {'amount': 1000, 'currencyCode': 'EUR'},
      'surchargeAmount': {'amount': 25, 'currencyCode': 'EUR'},
      'totalAmount': {'amount': 1025, 'currencyCode': 'EUR'},
    },
  ],
};

const _currencyConversionJson = {
  'docSessionId': 'doc-1',
  'result': {
    'result': 'Allowed',
    'resultReason': 'test reason',
  },
  'proposal': {
    'baseAmount': {'amount': 1000, 'currencyCode': 'EUR'},
    'targetAmount': {'amount': 1200, 'currencyCode': 'USD'},
    'rate': {
      'exchangeRate': 1.2,
      'invertedExchangeRate': 0.833,
      'markUpRate': 0.0,
      'quotationDateTime': '2024-01-01T00:00:00',
      'source': 'test',
    },
  },
};

void main() {
  late TestApiClient apiClient;
  late DefaultClientService service;

  setUp(() {
    apiClient = TestApiClient();
    service = DefaultClientService(CacheManager(), apiClient);
  });

  group('DefaultClientService.getIinDetails', () {
    test('returns response from API and caches it', () async {
      var callCount = 0;
      apiClient.setMockPost((_) async {
        callCount++;
        return successResponse(_iinDetailsJson);
      });

      final result = await service.getIinDetails('42424242', _paymentContext);

      expect(callCount, 1);
      expect(result.status, equals(IinStatus.supported));
      expect(result.countryCode, equals('NL'));
      expect(result.paymentProductId, equals(1));
    });

    test('returns cached value on subsequent call with same bin', () async {
      var callCount = 0;
      apiClient.setMockPost((_) async {
        callCount++;
        return successResponse(_iinDetailsJson);
      });

      final first = await service.getIinDetails('42424242', _paymentContext);
      final second = await service.getIinDetails('42424242', _paymentContext);

      expect(callCount, 1);
      expect(first, same(second));
    });

    test('calls API again for different bin', () async {
      var callCount = 0;
      apiClient.setMockPost((_) async {
        callCount++;
        return successResponse(_iinDetailsJson);
      });

      await service.getIinDetails('42424242', _paymentContext);
      await service.getIinDetails('12345678', _paymentContext);

      expect(callCount, 2);
    });

    test('sends correct path and body to API', () async {
      String? capturedPath;
      apiClient.setMockPost((path) async {
        capturedPath = path;
        return successResponse(_iinDetailsJson);
      });

      await service.getIinDetails('42424242', _paymentContext);

      expect(capturedPath, equals('services/getIINdetails'));
    });

    test('throws InvalidArgumentError for less than 6 digits', () async {
      expect(
        () => service.getIinDetails('12345', _paymentContext),
        throwsA(isA<InvalidArgumentError>()),
      );
    });

    test('returns notEnoughDigits status for empty string', () async {
      expect(
        () => service.getIinDetails('', _paymentContext),
        throwsA(
          isA<InvalidArgumentError>().having(
            (error) => (error.metadata as IinDetailsResponse?)?.status,
            'status',
            equals(IinStatus.notEnoughDigits),
          ),
        ),
      );
    });

    test('getIinDetails_WhenPartialCardNumberHasSpaces_FormatsToRemoveSpacesBeforeSending', () async {
      apiClient.setMockPost((_) async => successResponse(_iinDetailsJson));

      await service.getIinDetails('1234 5678 9', _paymentContext);

      final body = jsonDecode(apiClient.capturedPostBody!) as Map<String, dynamic>;
      expect(body['bin'], equals('12345678'));
    });

    test('getIinDetails_WhenApiResponseIsInvalid_ReturnsUnknownStatus', () async {
      apiClient.setMockPost((_) async => errorResponse({}));

      final result = await service.getIinDetails('42424242', _paymentContext);

      expect(result.status, equals(IinStatus.unknown));
    });

    test('getIinDetails_WhenIsAllowedInContextIsFalse_MapsExistingButNotAllowedStatus', () async {
      apiClient.setMockPost((_) async => successResponse({
            'isAllowedInContext': false,
            'countryCode': 'NL',
            'paymentProductId': 1,
            'coBrands': [],
          }));

      final result = await service.getIinDetails('42424242', _paymentContext);

      expect(result.status, equals(IinStatus.existingButNotAllowed));
    });

    test('getIinDetails_WhenIsAllowedInContextIsAbsent_MapsSupportedStatus', () async {
      apiClient.setMockPost((_) async => successResponse({
            'countryCode': 'NL',
            'paymentProductId': 1,
            'coBrands': [],
          }));

      final result = await service.getIinDetails('42424242', _paymentContext);

      expect(result.status, equals(IinStatus.supported));
    });
  });

  group('DefaultClientService.getSurchargeCalculation', () {
    test('returns response from API and caches it', () async {
      var callCount = 0;
      apiClient.setMockPost((_) async {
        callCount++;
        return successResponse(_surchargeJson);
      });

      final result = await service.getSurchargeCalculation(_amountOfMoney, _cardSource);

      expect(callCount, 1);
      expect(result.surcharges, hasLength(1));
      expect(result.surcharges.first.paymentProductId, equals(1));
    });

    test('returns cached value on subsequent call with same parameters', () async {
      var callCount = 0;
      apiClient.setMockPost((_) async {
        callCount++;
        return successResponse(_surchargeJson);
      });

      final first = await service.getSurchargeCalculation(_amountOfMoney, _cardSource);
      final second = await service.getSurchargeCalculation(_amountOfMoney, _cardSource);

      expect(callCount, 1);
      expect(first, same(second));
    });

    test('sends correct path to API', () async {
      String? capturedPath;
      apiClient.setMockPost((path) async {
        capturedPath = path;
        return successResponse(_surchargeJson);
      });

      await service.getSurchargeCalculation(_amountOfMoney, _cardSource);

      expect(capturedPath, equals('services/surchargeCalculation'));
    });

    test('getSurchargeCalculation_WhenCardSourceIsToken_SendsTokenInRequestBody', () async {
      apiClient.setMockPost((_) async => successResponse(_surchargeJson));

      await service.getSurchargeCalculation(_amountOfMoney, CardSourceWithToken('test-token-123'));

      final body = jsonDecode(apiClient.capturedPostBody!) as Map<String, dynamic>;
      final cardSource = body['cardSource'] as Map<String, dynamic>;
      expect(cardSource, equals({'token': 'test-token-123'}));
    });

    test('getSurchargeCalculation_WhenApiResponseIsInvalid_ThrowsResponseError', () {
      apiClient.setMockPost((_) async => errorResponse({}));

      expect(
        service.getSurchargeCalculation(_amountOfMoney, _cardSource),
        throwsA(
          isA<ResponseError>()
              .having((error) => error.message, 'message', 'Error while trying to fetch surcharge calculations.'),
        ),
      );
    });
  });

  group('DefaultClientService.getCurrencyConversionQuote', () {
    test('returns response from API and caches it', () async {
      var callCount = 0;
      apiClient.setMockPost((_) async {
        callCount++;
        return successResponse(_currencyConversionJson);
      });

      final result = await service.getCurrencyConversionQuote(_amountOfMoney, _cardSource);

      expect(callCount, 1);
      expect(result.docSessionId, equals('doc-1'));
    });

    test('returns cached value on subsequent call with same parameters', () async {
      var callCount = 0;
      apiClient.setMockPost((_) async {
        callCount++;
        return successResponse(_currencyConversionJson);
      });

      final first = await service.getCurrencyConversionQuote(_amountOfMoney, _cardSource);
      final second = await service.getCurrencyConversionQuote(_amountOfMoney, _cardSource);

      expect(callCount, 1);
      expect(first, same(second));
    });

    test('sends correct path to API', () async {
      String? capturedPath;
      apiClient.setMockPost((path) async {
        capturedPath = path;
        return successResponse(_currencyConversionJson);
      });

      await service.getCurrencyConversionQuote(_amountOfMoney, _cardSource);

      expect(capturedPath, equals('services/dccrate'));
    });

    test('getCurrencyConversionQuote_WhenCardSourceIsToken_SendsTokenInRequestBody', () async {
      apiClient.setMockPost((_) async => successResponse(_currencyConversionJson));

      await service.getCurrencyConversionQuote(_amountOfMoney, CardSourceWithToken('test-token-456'));

      final body = jsonDecode(apiClient.capturedPostBody!) as Map<String, dynamic>;
      final cardSource = body['cardSource'] as Map<String, dynamic>;
      expect(cardSource, equals({'token': 'test-token-456'}));
    });

    test('getCurrencyConversionQuote_WhenApiResponseIsInvalid_ThrowsResponseError', () {
      apiClient.setMockPost((_) async => errorResponse({}));

      expect(
        service.getCurrencyConversionQuote(_amountOfMoney, _cardSource),
        throwsA(
          isA<ResponseError>()
              .having((error) => error.message, 'message', 'Error while trying to fetch currency conversion.'),
        ),
      );
    });
  });
}
