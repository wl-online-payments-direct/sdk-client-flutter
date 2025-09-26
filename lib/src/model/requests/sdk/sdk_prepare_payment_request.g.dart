// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sdk_prepare_payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SdkPreparePaymentRequest _$SdkPreparePaymentRequestFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['paymentRequest'],
  );
  return SdkPreparePaymentRequest(
    PaymentRequest.fromJson(json['paymentRequest'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SdkPreparePaymentRequestToJson(
        SdkPreparePaymentRequest instance) =>
    <String, dynamic>{
      'paymentRequest': instance.paymentRequest.toJson(),
    };
