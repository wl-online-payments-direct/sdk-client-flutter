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

part of 'form_element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormElement _$FormElementFromJson(Map<String, dynamic> json) => FormElement(
      $enumDecode(_$FormElementTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$FormElementToJson(FormElement instance) =>
    <String, dynamic>{
      'type': _$FormElementTypeEnumMap[instance.type]!,
    };

const _$FormElementTypeEnumMap = {
  FormElementType.text: 'text',
  FormElementType.list: 'list',
  FormElementType.currency: 'currency',
  FormElementType.date: 'date',
  FormElementType.boolean: 'boolean',
};
