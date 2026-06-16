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

import '../domain/public_key/public_key_response.dart';
import 'encryption/jose_encryptor.dart';
import 'interfaces/jose_encryption_provider.dart';

/// Default implementation of [JoseEncryptionProvider].
///
/// Delegates to [JoseEncryptor] which uses [pointycastle] for pure-Dart
/// JOSE JWE compact serialization. Works on all Flutter platforms including web.
class DefaultJoseEncryptionProvider implements JoseEncryptionProvider {
  const DefaultJoseEncryptionProvider();

  @override
  String encrypt(Map<String, dynamic> plainText, PublicKeyResponse publicKeyResponse) {
    return JoseEncryptor.encrypt(plainText, publicKeyResponse);
  }
}
