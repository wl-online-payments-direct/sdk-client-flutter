// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentContext _$PaymentContextFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'amountOfMoney',
      'countryCode',
      'isRecurring',
      'forceBasicFlow'
    ],
  );
  return PaymentContext(
    AmountOfMoney.fromJson(json['amountOfMoney'] as Map<String, dynamic>),
    json['countryCode'] as String,
    json['isRecurring'] as bool,
    forceBasicFlow: json['forceBasicFlow'] as bool? ?? false,
  );
}

Map<String, dynamic> _$PaymentContextToJson(PaymentContext instance) =>
    <String, dynamic>{
      'amountOfMoney': instance.amountOfMoney.toJson(),
      'countryCode': instance.countryCode,
      'isRecurring': instance.isRecurring,
      'forceBasicFlow': instance.forceBasicFlow,
    };
