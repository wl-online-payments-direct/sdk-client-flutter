// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prepared_payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreparedPaymentRequest _$PreparedPaymentRequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    requiredKeys: const ['encryptedFields', 'encodedClientMetaInfo'],
  );
  return PreparedPaymentRequest(
    json['encryptedFields'] as String,
    json['encodedClientMetaInfo'] as String,
  );
}

Map<String, dynamic> _$PreparedPaymentRequestToJson(
  PreparedPaymentRequest instance,
) => <String, dynamic>{
  'encryptedFields': instance.encryptedFields,
  'encodedClientMetaInfo': instance.encodedClientMetaInfo,
};
