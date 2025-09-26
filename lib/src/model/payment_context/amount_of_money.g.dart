// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amount_of_money.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmountOfMoney _$AmountOfMoneyFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['amount', 'currencyCode'],
  );
  return AmountOfMoney(
    (json['amount'] as num).toInt(),
    json['currencyCode'] as String,
  );
}

Map<String, dynamic> _$AmountOfMoneyToJson(AmountOfMoney instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currencyCode': instance.currencyCode,
    };
