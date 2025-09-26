/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2025 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import 'package:flutter_test/flutter_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

void main() {
  group('ValidationRuleFixedList Cross-Platform Tests', () {
    test('should parse iOS format with allowedValues', () {
      final json = {
        'type': 'FIXEDLIST',
        'messageId': 'invalidSelection',
        'allowedValues': ['visa', 'mastercard', 'amex']
      };

      final rule = ValidationRuleFixedList.fromJson(json);

      expect(rule.type, equals(ValidationType.fixedList));
      expect(rule.messageId, equals('invalidSelection'));
      expect(rule.allowedValues, equals(['visa', 'mastercard', 'amex']));
    });

    test('should parse Android format with listValues', () {
      final json = {
        'type': 'FIXEDLIST',
        'messageId': 'invalidSelection',
        'listValues': ['visa', 'mastercard', 'amex']
      };

      final rule = ValidationRuleFixedList.fromJson(json);

      expect(rule.type, equals(ValidationType.fixedList));
      expect(rule.messageId, equals('invalidSelection'));
      expect(rule.allowedValues, equals(['visa', 'mastercard', 'amex']));
    });

    test('should throw exception when neither property exists', () {
      final json = {
        'type': 'FIXEDLIST',
        'messageId': 'invalidSelection',
      };

      expect(() => ValidationRuleFixedList.fromJson(json), throwsException);
    });

    test('should handle empty lists', () {
      final json = {
        'type': 'FIXEDLIST',
        'messageId': 'invalidSelection',
        'allowedValues': <String>[]
      };

      final rule = ValidationRuleFixedList.fromJson(json);
      expect(rule.allowedValues, isEmpty);
    });

    test('should serialize consistently with allowedValues', () {
      final rule = ValidationRuleFixedList(
        ValidationType.fixedList,
        'test',
        ['value1', 'value2']
      );

      final json = rule.toJson();
      
      expect(json['allowedValues'], equals(['value1', 'value2']));
      expect(json.containsKey('listValues'), false);
    });
  });
}