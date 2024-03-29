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
