// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_conversion_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyConversionRequest _$CurrencyConversionRequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, requiredKeys: const ['amountOfMoney']);
  return CurrencyConversionRequest(
      AmountOfMoney.fromJson(json['amountOfMoney'] as Map<String, dynamic>),
    )
    ..partialCreditCardNumber = json['partialCreditCardNumber'] as String?
    ..paymentProductId = (json['paymentProductId'] as num?)?.toInt()
    ..token = json['token'] as String?;
}

Map<String, dynamic> _$CurrencyConversionRequestToJson(
  CurrencyConversionRequest instance,
) => <String, dynamic>{
  'amountOfMoney': instance.amountOfMoney.toJson(),
  'partialCreditCardNumber': instance.partialCreditCardNumber,
  'paymentProductId': instance.paymentProductId,
  'token': instance.token,
};
