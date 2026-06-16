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

import 'dart:math';

import '../../domain/errors/encryption_error.dart';
import '../../domain/payment_request/credit_card_token_request.dart';
import '../../domain/payment_request/payment_request.dart';
import '../../domain/public_key/public_key_response.dart';
import '../interfaces/collected_device_information_provider.dart';
import '../interfaces/jose_encryption_provider.dart';

/// Builds JWE payloads from [PaymentRequest] and [CreditCardTokenRequest]
/// and delegates encryption to [JoseEncryptionProvider].
class Encryptor {
  final String _clientSessionId;
  final JoseEncryptionProvider _encryptionProvider;
  final CollectedDeviceInformationProvider _collectedDeviceInformationProvider;

  Encryptor(this._clientSessionId, this._encryptionProvider, this._collectedDeviceInformationProvider);

  String encrypt(PublicKeyResponse publicKey, PaymentRequest request) {
    return _encryptionProvider.encrypt(_buildPaymentRequestPayload(request), publicKey);
  }

  String encryptTokenRequest(PublicKeyResponse publicKey, CreditCardTokenRequest request) {
    return _encryptionProvider.encrypt(_buildTokenRequestPayload(request), publicKey);
  }

  Map<String, dynamic> _buildPaymentRequestPayload(PaymentRequest request) {
    final blob = <String, dynamic>{
      'clientSessionId': _clientSessionId,
      'nonce': _generateNonce(),
      'paymentProductId': request.paymentProduct.id,
      'tokenize': request.tokenize,
      'paymentValues': _mapValues(request.getValues()),
    };

    final collectedDeviceInformation = _collectedDeviceInformationProvider.getCollectedDeviceInformation();
    if (collectedDeviceInformation != null) {
      blob['collectedDeviceInformation'] = collectedDeviceInformation.toJson();
    }

    if (request.accountOnFile?.id != null) {
      blob['accountOnFileId'] = request.accountOnFile!.id;
    }

    return blob;
  }

  Map<String, dynamic> _buildTokenRequestPayload(CreditCardTokenRequest request) {
    final paymentProductId = request.getPaymentProductId();

    if (paymentProductId == null) {
      throw const EncryptionError(
        'Error encrypting credit card token request: the payment product ID is not set.',
      );
    }

    final blob = <String, dynamic>{
      'clientSessionId': _clientSessionId,
      'nonce': _generateNonce(),
      'paymentProductId': paymentProductId,
      'paymentValues': _mapTokenValues(request.getValues()),
    };

    final collectedDeviceInformation = _collectedDeviceInformationProvider.getCollectedDeviceInformation();
    if (collectedDeviceInformation != null) {
      blob['collectedDeviceInformation'] = collectedDeviceInformation.toJson();
    }

    return blob;
  }

  List<Map<String, String>> _mapValues(Map<String, String> values) {
    return values.entries.map((e) => {'key': e.key, 'value': e.value}).toList();
  }

  List<Map<String, String>> _mapTokenValues(Map<String, Object?> values) {
    return values.entries
        .where((e) => e.value != null)
        .map((e) => {'key': e.key, 'value': e.value.toString()})
        .toList();
  }

  static String _generateNonce() {
    final rng = Random.secure();
    final bytes = List.generate(16, (_) => rng.nextInt(256));

    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
