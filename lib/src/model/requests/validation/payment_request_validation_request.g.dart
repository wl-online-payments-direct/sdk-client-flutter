// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_request_validation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentRequestValidationRequest _$PaymentRequestValidationRequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, requiredKeys: const ['paymentRequest']);
  return PaymentRequestValidationRequest(
    PaymentRequest.fromJson(json['paymentRequest'] as Map<String, dynamic>),
    fieldId: json['fieldId'] as String?,
  );
}

Map<String, dynamic> _$PaymentRequestValidationRequestToJson(
  PaymentRequestValidationRequest instance,
) => <String, dynamic>{
  'paymentRequest': instance.paymentRequest.toJson(),
  'fieldId': instance.fieldId,
};
