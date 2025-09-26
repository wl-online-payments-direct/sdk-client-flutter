// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iin_details_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IinDetailsRequest _$IinDetailsRequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['partialCreditCardNumber', 'paymentContext'],
  );
  return IinDetailsRequest(
    partialCreditCardNumber: json['partialCreditCardNumber'] as String,
    paymentContext:
        PaymentContext.fromJson(json['paymentContext'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$IinDetailsRequestToJson(IinDetailsRequest instance) =>
    <String, dynamic>{
      'partialCreditCardNumber': instance.partialCreditCardNumber,
      'paymentContext': instance.paymentContext.toJson(),
    };
