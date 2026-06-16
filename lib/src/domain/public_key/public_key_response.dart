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

/// Represents a PublicKeyResponse object that is used for encrypting a [PaymentRequest].
class PublicKeyResponse {
  PublicKeyResponse(this.keyId, this.publicKey);

  String keyId;

  String publicKey;

  factory PublicKeyResponse.fromJson(Map<String, dynamic> json) {
    return PublicKeyResponse(
      json['keyId'] as String,
      json['publicKey'] as String,
    );
  }
}
