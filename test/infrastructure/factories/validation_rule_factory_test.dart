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

import 'package:flutter_test/flutter_test.dart';
import 'package:online_payments_sdk/src/domain/validation/rules/validation_rule_email_address.dart';
import 'package:online_payments_sdk/src/domain/validation/rules/validation_rule_expiration_date.dart';
import 'package:online_payments_sdk/src/domain/validation/rules/validation_rule_fixed_list.dart';
import 'package:online_payments_sdk/src/domain/validation/rules/validation_rule_iban.dart';
import 'package:online_payments_sdk/src/domain/validation/rules/validation_rule_length.dart';
import 'package:online_payments_sdk/src/domain/validation/rules/validation_rule_luhn.dart';
import 'package:online_payments_sdk/src/domain/validation/rules/validation_rule_range.dart';
import 'package:online_payments_sdk/src/domain/validation/rules/validation_rule_regular_expression.dart';
import 'package:online_payments_sdk/src/domain/validation/rules/validation_rule_terms_and_conditions.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/validators/rule_definitions/email_address_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/validators/rule_definitions/expiration_date_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/validators/rule_definitions/fixed_list_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/validators/rule_definitions/iban_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/validators/rule_definitions/length_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/validators/rule_definitions/luhn_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/validators/rule_definitions/range_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/validators/rule_definitions/regular_expression_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/validators/rule_definitions/terms_and_conditions_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/validators/validators_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/factories/validation_rule_factory.dart';

void main() {
  final factory = ValidationRuleFactory();

  group('ValidationRuleFactory.createRules', () {
    test('createRules_WhenValidatorsIsNull_ReturnsEmptyList', () {
      final rules = factory.createRules(null);

      expect(rules, isEmpty);
    });

    test('createRules_WhenLuhnValidatorPresent_CreatesLuhnRule', () {
      final rules = factory.createRules(const ValidatorsDto(luhn: LuhnDto()));

      expect(rules, hasLength(1));
      expect(rules.first, isA<ValidationRuleLuhn>());
    });

    test('createRules_WhenIbanValidatorPresent_CreatesIbanRule', () {
      final rules = factory.createRules(const ValidatorsDto(iban: IbanDto()));

      expect(rules, hasLength(1));
      expect(rules.first, isA<ValidationRuleIBAN>());
    });

    test('createRules_WhenTermsAndConditionsValidatorPresent_CreatesTermsAndConditionsRule', () {
      final rules = factory.createRules(const ValidatorsDto(termsAndConditions: TermsAndConditionsDto()));

      expect(rules, hasLength(1));
      expect(rules.first, isA<ValidationRuleTermsAndConditions>());
    });

    test('createRules_WhenRegularExpressionValidatorPresent_CreatesRegexRule', () {
      const validators = ValidatorsDto(
        regularExpression: RegularExpressionDto(regularExpression: '^[0-9]+\$'),
      );

      final rules = factory.createRules(validators);

      expect(rules, hasLength(1));
      expect(rules.first, isA<ValidationRuleRegularExpression>());
      expect((rules.first as ValidationRuleRegularExpression).pattern, equals('^[0-9]+\$'));
    });

    test('createRules_WhenEmailAddressValidatorPresent_CreatesEmailAddressRule', () {
      final rules = factory.createRules(const ValidatorsDto(emailAddress: EmailAddressDto()));

      expect(rules, hasLength(1));
      expect(rules.first, isA<ValidationRuleEmailAddress>());
    });

    test('createRules_WhenExpirationDateValidatorPresent_CreatesExpirationDateRule', () {
      final rules = factory.createRules(const ValidatorsDto(expirationDate: ExpirationDateDto()));

      expect(rules, hasLength(1));
      expect(rules.first, isA<ValidationRuleExpirationDate>());
    });

    test('createRules_WhenFixedListValidatorPresent_CreatesFixedListRule', () {
      const validators = ValidatorsDto(
        fixedList: FixedListDto(allowedValues: ['debit', 'credit']),
      );

      final rules = factory.createRules(validators);

      expect(rules, hasLength(1));
      expect(rules.first, isA<ValidationRuleFixedList>());
      expect((rules.first as ValidationRuleFixedList).allowedValues, equals(['debit', 'credit']));
    });

    test('createRules_WhenLengthValidatorPresent_CreatesLengthRule', () {
      const validators = ValidatorsDto(length: LengthDto(minLength: 2, maxLength: 16));

      final rules = factory.createRules(validators);

      expect(rules, hasLength(1));
      expect(rules.first, isA<ValidationRuleLength>());
      expect((rules.first as ValidationRuleLength).minLength, equals(2));
      expect((rules.first as ValidationRuleLength).maxLength, equals(16));
    });

    test('createRules_WhenRangeValidatorPresent_CreatesRangeRule', () {
      const validators = ValidatorsDto(range: RangeDto(minValue: 1, maxValue: 100));

      final rules = factory.createRules(validators);

      expect(rules, hasLength(1));
      expect(rules.first, isA<ValidationRuleRange>());
      expect((rules.first as ValidationRuleRange).minValue, equals(1));
      expect((rules.first as ValidationRuleRange).maxValue, equals(100));
    });

    test('createRules_WhenMultipleValidatorsPresent_CreatesAllRules', () {
      const validators = ValidatorsDto(
        luhn: LuhnDto(),
        length: LengthDto(minLength: 6, maxLength: 19),
        emailAddress: EmailAddressDto(),
      );

      final rules = factory.createRules(validators);

      expect(rules, hasLength(3));
      expect(rules.whereType<ValidationRuleLuhn>(), hasLength(1));
      expect(rules.whereType<ValidationRuleLength>(), hasLength(1));
      expect(rules.whereType<ValidationRuleEmailAddress>(), hasLength(1));
    });

    test('createRules_WhenLengthValidatorMissingMinLength_SkipsLengthRule', () {
      const validators = ValidatorsDto(length: LengthDto(minLength: null, maxLength: 16));

      final rules = factory.createRules(validators);

      expect(rules.whereType<ValidationRuleLength>(), isEmpty);
    });

    test('createRules_WhenLengthValidatorMissingMaxLength_SkipsLengthRule', () {
      const validators = ValidatorsDto(length: LengthDto(minLength: 2, maxLength: null));

      final rules = factory.createRules(validators);

      expect(rules.whereType<ValidationRuleLength>(), isEmpty);
    });

    test('createRules_WhenRangeValidatorMissingMinValue_SkipsRangeRule', () {
      const validators = ValidatorsDto(range: RangeDto(minValue: null, maxValue: 100));

      final rules = factory.createRules(validators);

      expect(rules.whereType<ValidationRuleRange>(), isEmpty);
    });

    test('createRules_WhenRangeValidatorMissingMaxValue_SkipsRangeRule', () {
      const validators = ValidatorsDto(range: RangeDto(minValue: 1, maxValue: null));

      final rules = factory.createRules(validators);

      expect(rules.whereType<ValidationRuleRange>(), isEmpty);
    });
  });
}
