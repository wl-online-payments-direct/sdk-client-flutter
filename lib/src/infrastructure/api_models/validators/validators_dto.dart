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
import 'rule_definitions/email_address_dto.dart';
import 'rule_definitions/expiration_date_dto.dart';
import 'rule_definitions/fixed_list_dto.dart';
import 'rule_definitions/iban_dto.dart';
import 'rule_definitions/length_dto.dart';
import 'rule_definitions/luhn_dto.dart';
import 'rule_definitions/range_dto.dart';
import 'rule_definitions/regular_expression_dto.dart';
import 'rule_definitions/terms_and_conditions_dto.dart';

class ValidatorsDto {
  final EmailAddressDto? emailAddress;
  final ExpirationDateDto? expirationDate;
  final FixedListDto? fixedList;
  final IbanDto? iban;
  final LengthDto? length;
  final LuhnDto? luhn;
  final RangeDto? range;
  final RegularExpressionDto? regularExpression;
  final TermsAndConditionsDto? termsAndConditions;

  const ValidatorsDto({
    this.emailAddress,
    this.expirationDate,
    this.fixedList,
    this.iban,
    this.length,
    this.luhn,
    this.range,
    this.regularExpression,
    this.termsAndConditions,
  });

  factory ValidatorsDto.fromJson(Map<String, dynamic> json) => ValidatorsDto(
        emailAddress: json['emailAddress'] != null
            ? EmailAddressDto.fromJson(json['emailAddress'] as Map<String, dynamic>)
            : null,
        expirationDate: json['expirationDate'] != null
            ? ExpirationDateDto.fromJson(json['expirationDate'] as Map<String, dynamic>)
            : null,
        fixedList: json['fixedList'] != null
            ? FixedListDto.fromJson(json['fixedList'] as Map<String, dynamic>)
            : null,
        iban: json['iban'] != null ? IbanDto.fromJson(json['iban'] as Map<String, dynamic>) : null,
        length: json['length'] != null ? LengthDto.fromJson(json['length'] as Map<String, dynamic>) : null,
        luhn: json['luhn'] != null ? LuhnDto.fromJson(json['luhn'] as Map<String, dynamic>) : null,
        range: json['range'] != null ? RangeDto.fromJson(json['range'] as Map<String, dynamic>) : null,
        regularExpression: json['regularExpression'] != null
            ? RegularExpressionDto.fromJson(json['regularExpression'] as Map<String, dynamic>)
            : null,
        termsAndConditions: json['termsAndConditions'] != null
            ? TermsAndConditionsDto.fromJson(json['termsAndConditions'] as Map<String, dynamic>)
            : null,
      );

  factory ValidatorsDto.fromValidationRules(List<dynamic> rules) {
    EmailAddressDto? emailAddress;
    ExpirationDateDto? expirationDate;
    FixedListDto? fixedList;
    IbanDto? iban;
    LengthDto? length;
    LuhnDto? luhn;
    RangeDto? range;
    RegularExpressionDto? regularExpression;
    TermsAndConditionsDto? termsAndConditions;

    for (final rule in rules) {
      final ruleJson = Map<String, dynamic>.from(rule as Map);
      final type = ruleJson['type'] as String? ?? ruleJson['messageId'] as String? ?? '';

      switch (type) {
        case 'emailAddress':
          emailAddress = EmailAddressDto.fromJson(ruleJson);
          break;
        case 'expirationDate':
          expirationDate = ExpirationDateDto.fromJson(ruleJson);
          break;
        case 'fixedList':
          fixedList = FixedListDto.fromJson(ruleJson);
          break;
        case 'iban':
          iban = IbanDto.fromJson(ruleJson);
          break;
        case 'length':
          length = LengthDto.fromJson(ruleJson);
          break;
        case 'luhn':
          luhn = LuhnDto.fromJson(ruleJson);
          break;
        case 'range':
          range = RangeDto.fromJson(ruleJson);
          break;
        case 'regularExpression':
          regularExpression = RegularExpressionDto.fromJson(ruleJson);
          break;
        case 'termsAndConditions':
          termsAndConditions = TermsAndConditionsDto.fromJson(ruleJson);
          break;
      }
    }

    return ValidatorsDto(
      emailAddress: emailAddress,
      expirationDate: expirationDate,
      fixedList: fixedList,
      iban: iban,
      length: length,
      luhn: luhn,
      range: range,
      regularExpression: regularExpression,
      termsAndConditions: termsAndConditions,
    );
  }
}
