/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2026 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import 'data_restrictions_dto.dart';
import 'display_hints/product_field_display_hints_dto.dart';

class PaymentProductFieldDto {
  final String id;
  final String type;
  final bool? usedForLookup;
  final DataRestrictionsDto dataRestrictions;
  final ProductFieldDisplayHintsDto? displayHints;

  const PaymentProductFieldDto({
    required this.id,
    required this.type,
    required this.dataRestrictions,
    this.usedForLookup,
    this.displayHints,
  });

  factory PaymentProductFieldDto.fromJson(Map<String, dynamic> json) => PaymentProductFieldDto(
        id: json['id'] as String? ?? '',
        type: json['type']?.toString() ?? '',
        usedForLookup: json['usedForLookup'] as bool?,
        dataRestrictions: json['dataRestrictions'] != null
            ? DataRestrictionsDto.fromJson(json['dataRestrictions'] as Map<String, dynamic>)
            : const DataRestrictionsDto(),
        displayHints: json['displayHints'] != null
            ? ProductFieldDisplayHintsDto.fromJson(json['displayHints'] as Map<String, dynamic>)
            : null,
      );
}
