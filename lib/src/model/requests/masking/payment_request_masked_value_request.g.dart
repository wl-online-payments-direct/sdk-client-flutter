// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_request_masked_value_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentRequestMaskedValueRequest _$PaymentRequestMaskedValueRequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, requiredKeys: const ['request', 'fieldId']);
  return PaymentRequestMaskedValueRequest(
    PaymentRequest.fromJson(json['request'] as Map<String, dynamic>),
    json['fieldId'] as String,
  );
}

Map<String, dynamic> _$PaymentRequestMaskedValueRequestToJson(
  PaymentRequestMaskedValueRequest instance,
) => <String, dynamic>{
  'request': instance.request.toJson(),
  'fieldId': instance.fieldId,
};
