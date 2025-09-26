/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2025 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import 'package:json_annotation/json_annotation.dart';

part 'public_key.g.dart';

/// Represents a PublicKey object that is used for encrypting a [PaymentRequest].
@JsonSerializable(explicitToJson: true)
class PublicKey {
  PublicKey(this.keyId, this.publicKey);

  @JsonKey(required: true)
  String keyId;

  @JsonKey(required: true)
  String publicKey;

  factory PublicKey.fromJson(Map<String, dynamic> json) => _$PublicKeyFromJson(json);

  Map<String, dynamic> toJson() => _$PublicKeyToJson(this);
}
