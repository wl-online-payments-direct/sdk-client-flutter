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
