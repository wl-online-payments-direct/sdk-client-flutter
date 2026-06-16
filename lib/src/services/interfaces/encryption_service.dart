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

import '../../domain/payment_request/credit_card_token_request.dart';
import '../../domain/payment_request/encrypted_request.dart';
import '../../domain/payment_request/payment_request.dart';
import '../../domain/public_key/public_key_response.dart';

abstract class EncryptionService {
  Future<PublicKeyResponse> getPublicKey();

  Future<EncryptedRequest> encryptPaymentRequest(PaymentRequest request);

  Future<EncryptedRequest> encryptTokenRequest(CreditCardTokenRequest tokenRequest);
}
