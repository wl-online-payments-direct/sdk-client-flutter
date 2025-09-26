// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['paymentProduct', 'tokenize'],
  );
  return PaymentRequest(
    paymentProduct:
        PaymentProduct.fromJson(json['paymentProduct'] as Map<String, dynamic>),
    tokenize: json['tokenize'] as bool? ?? false,
    accountOnFile: json['accountOnFile'] == null
        ? null
        : AccountOnFile.fromJson(json['accountOnFile'] as Map<String, dynamic>),
  )
    ..fieldValues = Map<String, String>.from(json['fieldValues'] as Map)
    ..errorMessageIds = (json['errorMessageIds'] as List<dynamic>)
        .map((e) => ValidationErrorMessage.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$PaymentRequestToJson(PaymentRequest instance) =>
    <String, dynamic>{
      'paymentProduct': instance.paymentProduct.toJson(),
      'accountOnFile': instance.accountOnFile?.toJson(),
      'fieldValues': instance.fieldValues,
      'errorMessageIds':
          instance.errorMessageIds.map((e) => e.toJson()).toList(),
      'tokenize': instance.tokenize,
    };
