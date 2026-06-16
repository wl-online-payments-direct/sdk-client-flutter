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
import 'package:online_payments_sdk/src/domain/configuration/sdk_configuration.dart';
import 'package:online_payments_sdk/src/domain/configuration/session_data.dart';
import 'package:online_payments_sdk/src/infrastructure/factories/default_service_factory.dart';
import 'package:online_payments_sdk/src/infrastructure/utils/cache_manager.dart';
import 'package:online_payments_sdk/src/services/default_client_service.dart';
import 'package:online_payments_sdk/src/services/default_encryption_service.dart';
import 'package:online_payments_sdk/src/services/default_payment_product_service.dart';

import '../../helpers/test_http_client.dart';

final _sessionData = SessionData(
  clientSessionId: 'test-session-id',
  customerId: 'test-customer-id',
  clientApiUrl: 'https://api.example.com/client',
  assetUrl: 'https://assets.example.com',
);

void main() {
  group('DefaultServiceFactory', () {
    test('creates all default instances', () {
      final factory = DefaultServiceFactory(_sessionData);

      expect(factory.getClientService(), isNotNull);
      expect(factory.getClientService(), isA<DefaultClientService>());
      expect(factory.getEncryptionService(), isNotNull);
      expect(factory.getEncryptionService(), isA<DefaultEncryptionService>());
      expect(factory.getPaymentProductService(), isNotNull);
      expect(factory.getPaymentProductService(), isA<DefaultPaymentProductService>());
    });

    test('always returns the same service instance (singleton per factory)', () {
      final factory = DefaultServiceFactory(_sessionData);

      expect(factory.getClientService(), same(factory.getClientService()));
      expect(factory.getEncryptionService(), same(factory.getEncryptionService()));
      expect(factory.getPaymentProductService(), same(factory.getPaymentProductService()));
    });

    test('getCacheManager_WhenCalledMultipleTimes_ReturnsSameInstance', () {
      final factory = DefaultServiceFactory(_sessionData);

      expect(factory.getCacheManager(), same(factory.getCacheManager()));
    });

    test('constructor_DefaultServicesShareSameCacheManagerInstance', () {
      final factory = DefaultServiceFactory(_sessionData);
      final CacheManager cacheManager = factory.getCacheManager();

      expect(
        (factory.getClientService() as DefaultClientService).cacheManager,
        same(cacheManager),
      );
      expect(
        (factory.getEncryptionService() as DefaultEncryptionService).cacheManager,
        same(cacheManager),
      );
      expect(
        (factory.getPaymentProductService() as DefaultPaymentProductService).cacheManager,
        same(cacheManager),
      );
    });

    test('constructor_WithSdkConfiguration_PassesAppIdentifierToApiClient', () async {
      final mockHttp = TestHttpClient();
      mockHttp.setResponse(200, {'keyId': 'test', 'publicKey': 'test'});

      final factory = DefaultServiceFactory(
        _sessionData,
        configuration: const SdkConfiguration(appIdentifier: 'my-app'),
        httpClient: mockHttp,
      );

      await factory.getEncryptionService().getPublicKey();

      expect(mockHttp.capturedRequests, isNotEmpty);
      final headers = mockHttp.capturedRequests.first.headers;
      final metaInfo = headers['X-GCS-ClientMetaInfo']!;
      final decoded = utf8.decode(base64Url.decode(base64Url.normalize(metaInfo)));
      final meta = jsonDecode(decoded) as Map<String, dynamic>;
      expect(meta['appIdentifier'], equals('my-app'));
    });
  });
}
