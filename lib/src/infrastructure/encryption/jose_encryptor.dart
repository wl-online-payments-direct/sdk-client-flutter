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
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/export.dart';

import '../../domain/errors/encryption_error.dart';
import '../../domain/public_key/public_key_response.dart';

/// Pure Dart JOSE JWE compact serialization encryptor.
///
/// Implements A256CBC-HS512 content encryption with RSA-OAEP key encryption
/// as specified in RFC 7516. This is a port of the RN/JS SDK JOSEEncryptor.
class JoseEncryptor {
  const JoseEncryptor._();

  static const _cekLength = 64; // 512 bits
  static const _ivLength = 16; // 128 bits

  /// Encrypts [plainText] and returns a JWE compact serialization string.
  static String encrypt(Map<String, dynamic> plainText, PublicKeyResponse publicKeyResponse) {
    final payload = jsonEncode(plainText);

    // 1. Build and base64url-encode the protected header
    final header = jsonEncode({'alg': 'RSA-OAEP', 'enc': 'A256CBC-HS512', 'kid': publicKeyResponse.keyId});
    final encodedHeader = _base64UrlEncodeString(header);

    // 2. Generate 512-bit CEK; split into macKey (first 32 bytes) and encKey (last 32 bytes)
    final cek = _randomBytes(_cekLength);
    final macKey = cek.sublist(0, 32);
    final encKey = cek.sublist(32);

    // 3. Encrypt CEK with RSA-OAEP using the server public key
    final publicKey = _decodeRSAPublicKey(publicKeyResponse.publicKey);
    final encryptedCek = _rsaOaepEncrypt(cek, publicKey);
    final encodedEncryptedCek = _base64UrlEncodeBytes(encryptedCek);

    // 4. Generate 128-bit IV
    final iv = _randomBytes(_ivLength);
    final encodedIv = _base64UrlEncodeBytes(iv);

    // 5. Encrypt payload with AES-CBC + PKCS7 padding
    final ciphertext = _aesCbcEncrypt(utf8.encode(payload), encKey, iv);
    final encodedCiphertext = _base64UrlEncodeBytes(ciphertext);

    // 6. Compute HMAC-SHA512 over AAD per RFC 7516:
    //    ASCII(encodedHeader) || IV || ciphertext || AL
    final al = _buildAL(encodedHeader);
    final hmacInput = Uint8List.fromList([
      ...ascii.encode(encodedHeader),
      ...iv,
      ...ciphertext,
      ...al,
    ]);
    final hmac = _hmacSha512(macKey, hmacInput);

    // 7. Auth tag = first 32 bytes of HMAC
    final encodedAuthTag = _base64UrlEncodeBytes(hmac.sublist(0, 32));

    return '$encodedHeader.$encodedEncryptedCek.$encodedIv.$encodedCiphertext.$encodedAuthTag';
  }

  static Uint8List _randomBytes(int length) {
    final rng = Random.secure();

    return Uint8List.fromList(List.generate(length, (_) => rng.nextInt(256)));
  }

  static String _base64UrlEncodeString(String s) {
    return _base64UrlEncodeBytes(utf8.encode(s));
  }

  static String _base64UrlEncodeBytes(List<int> bytes) {
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  static RSAPublicKey _decodeRSAPublicKey(String base64Key) {
    // Normalize to standard base64 and ensure padding
    final normalized = base64Key.replaceAll('-', '+').replaceAll('_', '/');
    final derBytes = base64.decode(base64.normalize(normalized));

    // Parse SubjectPublicKeyInfo DER: SEQUENCE { AlgorithmIdentifier, BIT STRING }
    final topSeq = ASN1Parser(derBytes).nextObject() as ASN1Sequence;
    final bitString = topSeq.elements![1] as ASN1BitString;

    // stringValues contains the RSA public key DER bytes (unused-bits prefix already excluded)
    final rsaDer = Uint8List.fromList(bitString.stringValues!);

    // Parse RSAPublicKey DER: SEQUENCE { INTEGER modulus, INTEGER exponent }
    final rsaSeq = ASN1Parser(rsaDer).nextObject() as ASN1Sequence;
    final modulus = (rsaSeq.elements![0] as ASN1Integer).integer;
    final exponent = (rsaSeq.elements![1] as ASN1Integer).integer;

    if (modulus == null || exponent == null) {
      throw const EncryptionError('Failed to decode RSA public key from server response.');
    }

    return RSAPublicKey(modulus, exponent);
  }

  static Uint8List _rsaOaepEncrypt(Uint8List data, RSAPublicKey publicKey) {
    final cipher = OAEPEncoding.withSHA1(RSAEngine());
    cipher.init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

    return cipher.process(data);
  }

  static Uint8List _aesCbcEncrypt(List<int> plaintext, Uint8List key, Uint8List iv) {
    final cipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(AESEngine()),
    );
    cipher.init(
      true,
      PaddedBlockCipherParameters(
        ParametersWithIV(KeyParameter(key), iv),
        null,
      ),
    );

    return cipher.process(Uint8List.fromList(plaintext));
  }

  /// Builds AL: the 64-bit big-endian representation of [encodedHeader]'s bit length.
  static Uint8List _buildAL(String encodedHeader) {
    final al = ByteData(8);
    al.setUint32(0, 0, Endian.big);
    al.setUint32(4, encodedHeader.length * 8, Endian.big);

    return al.buffer.asUint8List();
  }

  static Uint8List _hmacSha512(Uint8List key, Uint8List data) {
    final hmac = HMac(SHA512Digest(), 128);
    hmac.init(KeyParameter(key));
    hmac.update(data, 0, data.length);
    final out = Uint8List(64); // SHA-512 output = 64 bytes
    hmac.doFinal(out, 0);

    return out;
  }
}
