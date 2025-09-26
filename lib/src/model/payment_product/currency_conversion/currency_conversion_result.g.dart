// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_conversion_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyConversionResult _$CurrencyConversionResultFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['result'],
  );
  return CurrencyConversionResult(
    $enumDecode(_$ConversionResultTypeEnumMap, json['result']),
    resultReason: json['resultReason'] as String?,
  );
}

Map<String, dynamic> _$CurrencyConversionResultToJson(
        CurrencyConversionResult instance) =>
    <String, dynamic>{
      'result': _$ConversionResultTypeEnumMap[instance.result]!,
      'resultReason': instance.resultReason,
    };

const _$ConversionResultTypeEnumMap = {
  ConversionResultType.allowed: 'Allowed',
  ConversionResultType.invalidCard: 'InvalidCard',
  ConversionResultType.invalidMerchant: 'InvalidMerchant',
  ConversionResultType.noRate: 'NoRate',
  ConversionResultType.notAvailable: 'NotAvailable',
};
