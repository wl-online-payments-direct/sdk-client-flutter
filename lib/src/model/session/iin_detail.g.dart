/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2023 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iin_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IinDetail _$IinDetailFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['paymentProductId', 'isAllowedInContext', 'cardType'],
  );
  return IinDetail(
    json['paymentProductId'] as String,
    json['isAllowedInContext'] as bool,
    $enumDecode(_$CardTypeEnumMap, json['cardType']),
  );
}

Map<String, dynamic> _$IinDetailToJson(IinDetail instance) => <String, dynamic>{
      'paymentProductId': instance.paymentProductId,
      'isAllowedInContext': instance.isAllowedInContext,
      'cardType': _$CardTypeEnumMap[instance.cardType]!,
    };

const _$CardTypeEnumMap = {
  CardType.credit: 'Credit',
  CardType.debit: 'Debit',
  CardType.prepaid: 'Prepaid',
};
