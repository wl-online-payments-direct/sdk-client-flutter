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
import 'account_on_file_attribute_dto.dart';
import 'account_on_file_display_hints_dto.dart';

class AccountOnFileDto {
  final String id;
  final int paymentProductId;
  final List<AccountOnFileAttributeDto> attributes;
  final AccountOnFileDisplayHintsDto? displayHints;

  AccountOnFileDto({
    required this.id,
    required this.paymentProductId,
    this.attributes = const [],
    this.displayHints,
  });

  factory AccountOnFileDto.fromJson(Map<String, dynamic> json) => AccountOnFileDto(
        id: json['id'].toString(),
        paymentProductId: (json['paymentProductId'] as num).toInt(),
        attributes: (json['attributes'] as List<dynamic>? ?? [])
            .map((e) => AccountOnFileAttributeDto.fromJson(e as Map<String, dynamic>))
            .toList(),
        displayHints: json['displayHints'] != null
            ? AccountOnFileDisplayHintsDto.fromJson(json['displayHints'] as Map<String, dynamic>)
            : null,
      );
}
