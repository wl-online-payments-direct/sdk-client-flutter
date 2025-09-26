// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RateDetails _$RateDetailsFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'exchangeRate',
      'invertedExchangeRate',
      'markUpRate',
      'quotationDateTime',
      'source'
    ],
  );
  return RateDetails(
    (json['exchangeRate'] as num).toDouble(),
    (json['invertedExchangeRate'] as num).toDouble(),
    (json['markUpRate'] as num).toDouble(),
    json['quotationDateTime'] as String,
    json['source'] as String,
  );
}

Map<String, dynamic> _$RateDetailsToJson(RateDetails instance) =>
    <String, dynamic>{
      'exchangeRate': instance.exchangeRate,
      'invertedExchangeRate': instance.invertedExchangeRate,
      'markUpRate': instance.markUpRate,
      'quotationDateTime': instance.quotationDateTime,
      'source': instance.source,
    };
