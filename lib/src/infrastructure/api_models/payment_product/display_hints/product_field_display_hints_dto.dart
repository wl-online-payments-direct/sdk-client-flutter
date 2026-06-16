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
import 'form_element_dto.dart';
import 'tooltip_dto.dart';

class ProductFieldDisplayHintsDto {
  final bool alwaysShow;
  final int displayOrder;
  final FormElementDto? formElement;
  final String? label;
  final String? link;
  final String? mask;
  final bool obfuscate;
  final String? placeholderLabel;
  final String? preferredInputType;
  final TooltipDto? tooltip;

  ProductFieldDisplayHintsDto({
    this.alwaysShow = false,
    required this.displayOrder,
    this.formElement,
    this.label,
    this.link,
    this.mask,
    this.obfuscate = false,
    this.placeholderLabel,
    this.preferredInputType,
    this.tooltip,
  });

  factory ProductFieldDisplayHintsDto.fromJson(Map<String, dynamic> json) => ProductFieldDisplayHintsDto(
        alwaysShow: json['alwaysShow'] as bool? ?? false,
        displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
        formElement: json['formElement'] != null
            ? FormElementDto.fromJson(json['formElement'] as Map<String, dynamic>)
            : null,
        label: json['label'] as String?,
        link: json['link'] as String?,
        mask: json['mask'] as String?,
        obfuscate: json['obfuscate'] as bool? ?? false,
        placeholderLabel: json['placeholderLabel'] as String?,
        preferredInputType: json['preferredInputType'] as String?,
        tooltip: json['tooltip'] != null
            ? TooltipDto.fromJson(json['tooltip'] as Map<String, dynamic>)
            : null,
      );
}
