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
import '../validators/validators_dto.dart';

class DataRestrictionsDto {
  final bool isRequired;
  final ValidatorsDto validators;

  const DataRestrictionsDto({this.isRequired = false, this.validators = const ValidatorsDto()});

  factory DataRestrictionsDto.fromJson(Map<String, dynamic> json) {
    final validatorsJson = json['validators'];
    final validationRulesJson = json['validationRules'];

    return DataRestrictionsDto(
      isRequired: json['isRequired'] as bool? ?? false,
      validators: validatorsJson is Map<String, dynamic>
          ? ValidatorsDto.fromJson(validatorsJson)
          : validationRulesJson is List<dynamic>
              ? ValidatorsDto.fromValidationRules(validationRulesJson)
              : const ValidatorsDto(),
    );
  }
}
