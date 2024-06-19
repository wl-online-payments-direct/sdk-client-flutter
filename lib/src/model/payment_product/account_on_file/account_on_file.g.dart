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

part of 'account_on_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountOnFile _$AccountOnFileFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'paymentProductId'],
  );
  return AccountOnFile(
    json['id'] as String,
    json['paymentProductId'] as String,
    displayHints: json['displayHints'] == null
        ? null
        : AccountOnFileDisplayHints.fromJson(
            json['displayHints'] as Map<String, dynamic>),
    attributes: (json['attributes'] as List<dynamic>?)
            ?.map((e) =>
                AccountOnFileAttribute.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
    label: json['label'] as String? ?? "",
  );
}

Map<String, dynamic> _$AccountOnFileToJson(AccountOnFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paymentProductId': instance.paymentProductId,
      'displayHints': instance.displayHints?.toJson(),
      'attributes': instance.attributes.map((e) => e.toJson()).toList(),
      'label': instance.label,
    };
