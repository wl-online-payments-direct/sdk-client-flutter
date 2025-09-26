// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_request_all_masked_values_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentRequestAllMaskedValuesRequest
    _$PaymentRequestAllMaskedValuesRequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['request'],
  );
  return PaymentRequestAllMaskedValuesRequest(
    PaymentRequest.fromJson(json['request'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PaymentRequestAllMaskedValuesRequestToJson(
        PaymentRequestAllMaskedValuesRequest instance) =>
    <String, dynamic>{
      'request': instance.request.toJson(),
    };
