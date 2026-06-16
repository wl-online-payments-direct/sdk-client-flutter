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
import 'package:online_payments_sdk/src/domain/public_key/public_key_response.dart';
import 'package:online_payments_sdk/src/infrastructure/encryption/jose_encryptor.dart';

const _testKeyId = '2c3363b2-ce03-4079-90db-c8bf381ac49c';
const _testPublicKey =
    'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxMXRHSr5bSPvfiHQ8P1o'
    'Czg6GyPlpXqll28GKWJt7aX6usYzFwIC7+c6lQcVnkGB+5kEAX6Ek56LjkQDw48N'
    'V9qyoF8U91ih0XRhKtZ21CQmsfakmpY3BfVy1eY1l4OUHOABWkBo8pQCBbcBHb/r'
    'UVQVvLOd+jOeF6GIjtb7XJpkqiXKchNTm0qGLu8YjnRL3ZC5lqOX0qi9/HFMyWDw'
    'BSXZSLjTTkDF1UWalVeMt91b0Yij0SS0+ShL8gdt1EmGU9eEeaR1NPOH1thiPzVi7'
    'rFeSq1Fj+H65YPQBx2e4b07NzDF0xsbpB73BoSDeWNbMl8dvLJ7byn95IKIsCh9FQ'
    'IDAQAB';

PublicKeyResponse get _testKey => PublicKeyResponse(_testKeyId, _testPublicKey);

/// Decodes a base64url segment to a Map.
Map<String, dynamic> _decodeBase64UrlToJson(String segment) {
  final normalized = segment.replaceAll('-', '+').replaceAll('_', '/');
  final padded = normalized + '=' * ((4 - normalized.length % 4) % 4);
  return jsonDecode(utf8.decode(base64.decode(padded))) as Map<String, dynamic>;
}

/// Asserts that [token] is a valid compact JWE with 5 base64url parts and the expected header.
void _expectCompactJwe(String token, String kid) {
  final parts = token.split('.');
  expect(parts, hasLength(5), reason: 'JWE must have 5 parts');
  for (final part in parts) {
    expect(part, isNotEmpty);
    expect(part, matches(RegExp(r'^[A-Za-z0-9\-_]+$')), reason: 'Each part must be base64url');
  }

  final header = _decodeBase64UrlToJson(parts[0]);
  expect(header['alg'], equals('RSA-OAEP'));
  expect(header['enc'], equals('A256CBC-HS512'));
  expect(header['kid'], equals(kid));
}

void main() {
  group('JoseEncryptor.encrypt (SDK contract)', () {
    test('encrypts realistic payment payload used by SDK', () {
      final payload = {
        'clientSessionId': 'test-session-id',
        'nonce': '0123456789abcdef0123456789abcdef',
        'paymentProductId': 1,
        'tokenize': true,
        'accountOnFileId': '1234',
        'paymentValues': [
          {'key': 'cardNumber', 'value': '4567350000427977'},
          {'key': 'expiryDate', 'value': '1230'},
          {'key': 'cvv', 'value': '123'},
        ],
      };

      final encrypted = JoseEncryptor.encrypt(payload, _testKey);
      _expectCompactJwe(encrypted, _testKeyId);
    });

    test('supports unicode payload values (e.g. cardholder names)', () {
      final payload = {
        'clientSessionId': 'test-session-id',
        'nonce': '0123456789abcdef0123456789abcdef',
        'paymentProductId': 1,
        'paymentValues': [
          {'key': 'cardholderName', 'value': 'Darwin Núñez'},
        ],
      };

      final encrypted = JoseEncryptor.encrypt(payload, _testKey);
      _expectCompactJwe(encrypted, _testKeyId);
    });

    test('header is stable across multiple encryptions of same payload', () {
      final payload = {
        'clientSessionId': 's',
        'nonce': 'n',
        'paymentProductId': 1,
        'paymentValues': [
          {'key': 'k', 'value': 'v'},
        ],
      };

      final first = JoseEncryptor.encrypt(payload, _testKey);
      final second = JoseEncryptor.encrypt(payload, _testKey);

      expect(first.split('.')[0], equals(second.split('.')[0]));
    });

    test('produces different ciphertext on each call (random IV/CEK)', () {
      final payload = {'clientSessionId': 's', 'nonce': 'n', 'paymentProductId': 1};
      final first = JoseEncryptor.encrypt(payload, _testKey);
      final second = JoseEncryptor.encrypt(payload, _testKey);

      final firstParts = first.split('.');
      final secondParts = second.split('.');

      expect(
        firstParts[1] != secondParts[1] || firstParts[2] != secondParts[2] || firstParts[3] != secondParts[3],
        isTrue,
        reason: 'Random CEK/IV must produce different ciphertext',
      );
    });

    test('throws when public key is malformed', () {
      final malformed = PublicKeyResponse('kid', 'not-valid-base64-der!!!');
      expect(() => JoseEncryptor.encrypt({'a': 1}, malformed), throwsException);
    });
  });
}
