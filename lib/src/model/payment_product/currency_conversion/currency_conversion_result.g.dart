/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2024 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */

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
