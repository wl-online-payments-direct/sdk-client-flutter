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

import '../domain/configuration/sdk_configuration.dart';
import '../domain/errors/invalid_argument_error.dart';
import '../domain/payment_request/credit_card_token_request.dart';
import '../domain/payment_request/encrypted_request.dart';
import '../domain/payment_request/payment_request.dart';
import '../domain/public_key/public_key_response.dart';
import '../infrastructure/encryption/encryptor.dart';
import '../infrastructure/interfaces/api_client.dart';
import '../infrastructure/interfaces/device_information_provider.dart';
import '../infrastructure/utils/cache_manager.dart';
import '../infrastructure/utils/util.dart';
import 'base_service.dart';
import 'interfaces/encryption_service.dart';

class DefaultEncryptionService extends BaseService implements EncryptionService {
  final Encryptor _encryptor;
  final DeviceInformationProvider _deviceInformationProvider;
  final SdkConfiguration? _configuration;

  DefaultEncryptionService(
    this._encryptor,
    this._deviceInformationProvider,
    this._configuration,
    CacheManager cacheManager,
    ApiClient apiClient,
  ) : super(cacheManager, apiClient);

  @override
  Future<PublicKeyResponse> getPublicKey() async {
    const cacheKey = 'publicKey';

    if (cacheManager.has(cacheKey)) {
      return cacheManager.get<PublicKeyResponse>(cacheKey)!;
    }

    final response = await apiClient.get('crypto/publickey');

    validateResponse(response, 'Error while trying to fetch the public key.');

    final publicKey = PublicKeyResponse.fromJson(response.data);
    cacheManager.set(cacheKey, publicKey);

    return publicKey;
  }

  @override
  Future<EncryptedRequest> encryptPaymentRequest(PaymentRequest request) async {
    final validationResult = request.validate();

    if (!validationResult.isValid) {
      throw InvalidArgumentError(
        'The payment request is not valid.',
        metadata: validationResult,
      );
    }

    return _encrypt((publicKey) => _encryptor.encrypt(publicKey, request));
  }

  @override
  Future<EncryptedRequest> encryptTokenRequest(CreditCardTokenRequest request) async {
    return _encrypt((publicKey) => _encryptor.encryptTokenRequest(publicKey, request));
  }

  Future<EncryptedRequest> _encrypt(String Function(PublicKeyResponse) encryptFn) async {
    final publicKey = await getPublicKey();
    final encryptedCustomerInput = encryptFn(publicKey);
    final metadata = Util.getMetadata(
      provider: _deviceInformationProvider,
      appIdentifier: _configuration?.appIdentifier,
    );
    final encodedClientMetaInfo = Util.base64UrlEncode(jsonEncode(metadata.toJson()));

    return EncryptedRequest(encryptedCustomerInput, encodedClientMetaInfo: encodedClientMetaInfo);
  }
}
