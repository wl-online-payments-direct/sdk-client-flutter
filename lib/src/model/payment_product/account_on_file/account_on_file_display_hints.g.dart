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

part of 'account_on_file_display_hints.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountOnFileDisplayHints _$AccountOnFileDisplayHintsFromJson(
        Map<String, dynamic> json) =>
    AccountOnFileDisplayHints(
      (json['labelTemplate'] as List<dynamic>)
          .map((e) => LabelTemplateElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AccountOnFileDisplayHintsToJson(
        AccountOnFileDisplayHints instance) =>
    <String, dynamic>{
      'labelTemplate': instance.labelTemplate.map((e) => e.toJson()).toList(),
    };
