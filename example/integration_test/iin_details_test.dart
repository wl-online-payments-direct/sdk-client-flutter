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
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

import 'test_credentials.dart';
import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await TestCredentials.get();
  });

  group('sdk.getIinDetails', () {
    late OnlinePaymentSdk sdk;

    setUp(() => sdk = TestHelpers.createSdk());
    tearDown(() => sdk.dispose());

    test('getIinDetails_WithCardNumberOf6Digits_DoesNotThrow', () async {
      final result = await sdk.getIinDetails('401200', TestHelpers.createTestPaymentContext());

      expect(result, isA<IinDetailsResponse>());
    });

    test('getIinDetails_WithValidBin_ReturnsSupportedStatus', () async {
      final result = await sdk.getIinDetails('401200', TestHelpers.createTestPaymentContext());

      expect(result, isA<IinDetailsResponse>());
      expect(result.paymentProductId, isA<int?>());
      expect(result.countryCode, isA<String?>());
      expect(result.isAllowedInContext, isA<bool?>());
      expect(result.coBrands, isA<List<IinDetail>>());
      expect(result.status, equals(IinStatus.supported));
    });

    test('getIinDetails_WithUnknownCardNumber_ReturnsUnknownStatus', () async {
      final result = await sdk.getIinDetails('999999', TestHelpers.createTestPaymentContext());

      expect(result.status, equals(IinStatus.unknown));
    });

    test('getIinDetails_WithLessThan6Digits_ThrowsInvalidArgumentError', () async {
      await expectLater(
            () => sdk.getIinDetails('12345', TestHelpers.createTestPaymentContext()),
        throwsA(
          isA<InvalidArgumentError>()
              .having((error) => error.message, 'message', isNotEmpty)
              .having(
                (error) => error.metadata,
            'metadata',
            isA<IinDetailsResponse>().having(
                  (response) => response.status,
              'status',
              equals(IinStatus.notEnoughDigits),
            ),
          ),
        ),
      );
    });

    test('getIinDetails_CalledTwiceWithSameBin_ReturnsCachedResultOnSecondCall', () async {
      final (countingSdk, counter) = createSdkWithCounter();
      addTearDown(countingSdk.dispose);

      await countingSdk.getIinDetails('401200', TestHelpers.createTestPaymentContext());
      await countingSdk.getIinDetails('401200', TestHelpers.createTestPaymentContext());

      expect(counter.callCount, equals(1));
    });

    test('getIinDetails_WithDifferentCardNumbers_MakesNewApiCall', () async {
      final (countingSdk, counter) = createSdkWithCounter();
      addTearDown(countingSdk.dispose);

      await countingSdk.getIinDetails('401200', TestHelpers.createTestPaymentContext());
      await countingSdk.getIinDetails('456735', TestHelpers.createTestPaymentContext());

      expect(counter.callCount, equals(2));
    });

    test('getIinDetails_WithFullCardNumber_ReturnsSupported', () async {
      final result = await sdk.getIinDetails('4012001037141112', TestHelpers.createTestPaymentContext());

      expect(result, isA<IinDetailsResponse>());
      expect(result.status, equals(IinStatus.supported));
    });
  });

  group('sdk.getIinDetails deterministic HTTP scenarios', () {
    test('getIinDetails_WithCardNumberContainingSpaces_AcceptsAndNormalizesCardNumber', () async {
      final client = StubHttpClient((request) async {
        expect(request.method, equals('POST'));
        expect(request.url.path, contains('/services/getIINdetails'));

        final requestBody = jsonDecode((request as http.Request).body) as Map<String, dynamic>;

        expect(requestBody['bin'], equals('40120010'));
        expect(requestBody['paymentContext'], isA<Map<String, dynamic>>());

        return jsonResponse(
          200,
          {
            'paymentProductId': 1,
            'countryCode': 'NL',
            'isAllowedInContext': true,
          },
        );
      });

      final sdk = createSdkWithHttpClient(client);
      addTearDown(sdk.dispose);

      final result = await sdk.getIinDetails(
        '4012 0010 3714 1112',
        TestHelpers.createTestPaymentContext(),
      );

      expect(result.status, equals(IinStatus.supported));
      expect(result.paymentProductId, equals(1));
      expect(result.countryCode, equals('NL'));
      expect(result.isAllowedInContext, isTrue);
    });

    test('getIinDetails_WhenCardNotAllowedInContext_ReturnsExistingButNotAllowed', () async {
      final client = StubHttpClient((request) async {
        return jsonResponse(
          200,
          {
            'paymentProductId': 1,
            'countryCode': 'NL',
            'isAllowedInContext': false,
          },
        );
      });

      final sdk = createSdkWithHttpClient(client);
      addTearDown(sdk.dispose);

      final result = await sdk.getIinDetails('401200', TestHelpers.createTestPaymentContext());

      expect(result.status, equals(IinStatus.existingButNotAllowed));
      expect(result.paymentProductId, equals(1));
      expect(result.countryCode, equals('NL'));
      expect(result.isAllowedInContext, isFalse);
    });

    test('getIinDetails_WhenIsAllowedInContextAbsent_ReturnsSupportedStatus', () async {
      final client = StubHttpClient((request) async {
        return jsonResponse(
          200,
          {
            'paymentProductId': 1,
            'countryCode': 'NL',
          },
        );
      });

      final sdk = createSdkWithHttpClient(client);
      addTearDown(sdk.dispose);

      final result = await sdk.getIinDetails('401200', TestHelpers.createTestPaymentContext());

      expect(result.status, equals(IinStatus.supported));
      expect(result.paymentProductId, equals(1));
      expect(result.countryCode, equals('NL'));
      expect(result.isAllowedInContext, isNull);
    });
  });
}