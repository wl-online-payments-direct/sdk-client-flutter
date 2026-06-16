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

import 'package:http/http.dart' as http;

import '../../domain/configuration/sdk_configuration.dart';
import '../../domain/configuration/session_data.dart';
import '../../services/default_client_service.dart';
import '../../services/default_encryption_service.dart';
import '../../services/default_payment_product_service.dart';
import '../../services/interfaces/client_service.dart';
import '../../services/interfaces/encryption_service.dart';
import '../../services/interfaces/payment_product_service.dart';
import '../../services/models/apple_pay.dart';
import '../default_api_client.dart';
import '../default_jose_encryption_provider.dart';
import '../encryption/encryptor.dart';
import '../interfaces/device_information_provider.dart';
import '../interfaces/service_factory.dart';
import '../platform/collected_device_information_provider_factory.dart';
import '../platform/device_information_provider_factory.dart';
import '../utils/cache_manager.dart';
import 'default_payment_product_factory.dart';

/// Default implementation of [ServiceFactory].
/// Wires up HTTP client, cache, and service implementations.
class DefaultServiceFactory implements ServiceFactory {
  final SessionData _sessionData;
  final SdkConfiguration? _configuration;
  final ApplePay _applePay;

  late final CacheManager _cacheManager;
  late final DefaultApiClient _apiClient;
  late final DeviceInformationProvider _deviceInformationProvider;
  late final DefaultPaymentProductFactory _paymentProductFactory;
  late final PaymentProductService _paymentProductService;
  late final ClientService _clientService;
  late final EncryptionService _encryptionService;

  DefaultServiceFactory(
    this._sessionData, {
    SdkConfiguration? configuration,
    ApplePay? applePay,
    http.Client? httpClient,
  })  : _configuration = configuration,
        _applePay = applePay ?? const DefaultApplePay() {
    _cacheManager = CacheManager();
    _deviceInformationProvider = createDeviceInformationProvider();
    _apiClient = DefaultApiClient(
      clientApiUrl: _sessionData.clientApiUrl,
      customerId: _sessionData.customerId,
      clientSessionId: _sessionData.clientSessionId,
      deviceInformationProvider: _deviceInformationProvider,
      appIdentifier: _configuration?.appIdentifier,
      httpClient: httpClient,
    );
    _paymentProductFactory = DefaultPaymentProductFactory();
    _paymentProductService = DefaultPaymentProductService(
      _cacheManager,
      _apiClient,
      _paymentProductFactory,
      _applePay,
    );
    _clientService = DefaultClientService(_cacheManager, _apiClient);
    _encryptionService = DefaultEncryptionService(
      Encryptor(
        _sessionData.clientSessionId,
        const DefaultJoseEncryptionProvider(),
        createCollectedDeviceInformationProvider(),
      ),
      _deviceInformationProvider,
      _configuration,
      _cacheManager,
      _apiClient,
    );
  }

  @override
  PaymentProductService getPaymentProductService() => _paymentProductService;

  @override
  ClientService getClientService() => _clientService;

  @override
  EncryptionService getEncryptionService() => _encryptionService;

  @override
  void dispose() => _apiClient.close();

  CacheManager getCacheManager() => _cacheManager;
}
