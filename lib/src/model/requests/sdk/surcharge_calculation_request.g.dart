// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surcharge_calculation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurchargeCalculationRequest _$SurchargeCalculationRequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, requiredKeys: const ['amountOfMoney']);
  return SurchargeCalculationRequest(
      AmountOfMoney.fromJson(json['amountOfMoney'] as Map<String, dynamic>),
    )
    ..partialCreditCardNumber = json['partialCreditCardNumber'] as String?
    ..paymentProductId = (json['paymentProductId'] as num?)?.toInt()
    ..token = json['token'] as String?;
}

Map<String, dynamic> _$SurchargeCalculationRequestToJson(
  SurchargeCalculationRequest instance,
) => <String, dynamic>{
  'amountOfMoney': instance.amountOfMoney.toJson(),
  'partialCreditCardNumber': instance.partialCreditCardNumber,
  'paymentProductId': instance.paymentProductId,
  'token': instance.token,
};
