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
class AccountOnFileAttributeDto {
  final String key;
  final String value;
  final String? status;

  AccountOnFileAttributeDto({required this.key, required this.value, this.status});

  factory AccountOnFileAttributeDto.fromJson(Map<String, dynamic> json) => AccountOnFileAttributeDto(
        key: json['key'] as String,
        value: json['value'] as String,
        status: json['status'] as String?,
      );
}
