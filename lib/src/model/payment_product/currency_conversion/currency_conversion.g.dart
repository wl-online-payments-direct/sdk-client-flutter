// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_conversion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyConversion _$CurrencyConversionFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['dccSessionId', 'result', 'proposal'],
  );
  return CurrencyConversion(
    json['dccSessionId'] as String,
    CurrencyConversionResult.fromJson(json['result'] as Map<String, dynamic>),
    DccProposal.fromJson(json['proposal'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CurrencyConversionToJson(CurrencyConversion instance) =>
    <String, dynamic>{
      'dccSessionId': instance.dccSessionId,
      'result': instance.result.toJson(),
      'proposal': instance.proposal.toJson(),
    };
