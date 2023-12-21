/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2023 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicKey _$PublicKeyFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['keyId', 'publicKey'],
  );
  return PublicKey(
    json['keyId'] as String,
    json['publicKey'] as String,
  );
}

Map<String, dynamic> _$PublicKeyToJson(PublicKey instance) => <String, dynamic>{
      'keyId': instance.keyId,
      'publicKey': instance.publicKey,
    };
