// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicKey _$PublicKeyFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['keyId', 'publicKey']);
  return PublicKey(json['keyId'] as String, json['publicKey'] as String);
}

Map<String, dynamic> _$PublicKeyToJson(PublicKey instance) => <String, dynamic>{
  'keyId': instance.keyId,
  'publicKey': instance.publicKey,
};
