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
import 'account_on_file_label_template_dto.dart';

class AccountOnFileDisplayHintsDto {
  final String? logo;
  final List<AccountOnFileLabelTemplateDto> labelTemplate;

  AccountOnFileDisplayHintsDto({this.logo, this.labelTemplate = const []});

  factory AccountOnFileDisplayHintsDto.fromJson(Map<String, dynamic> json) => AccountOnFileDisplayHintsDto(
        logo: json['logo'] as String?,
        labelTemplate: (json['labelTemplate'] as List<dynamic>? ?? [])
            .map((e) => AccountOnFileLabelTemplateDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
