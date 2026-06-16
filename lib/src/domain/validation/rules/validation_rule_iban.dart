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

import '../rule_validation_result.dart';
import 'validation_rule.dart';

/// Used for validation of an IBAN number.
class ValidationRuleIBAN extends ValidationRule {
  ValidationRuleIBAN(super.type, super.messageId);

  @override
  RuleValidationResult validate(String value) {
    final normalized = value.replaceAll(RegExp(r'\s'), '').toUpperCase();

    if (!RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z0-9]{4}[0-9]{7}([A-Z0-9]?){0,16}$').hasMatch(normalized)) {
      return const RuleValidationResult(valid: false, message: 'IBAN is not in the correct format.');
    }

    // Move first 4 chars to end, replace letters with their numeric equivalents (A=10..Z=35)
    final rearranged = normalized.substring(4) + normalized.substring(0, 4);
    final numeric = rearranged.split('').map((c) {
      final code = c.codeUnitAt(0);
      return (code >= 65 && code <= 90) ? (code - 55).toString() : c;
    }).join();

    // Validate mod-97 checksum using block processing to avoid overflow
    var remainder = '';
    for (final ch in numeric.split('')) {
      remainder += ch;
      if (remainder.length >= 9) {
        remainder = (int.parse(remainder) % 97).toString();
      }
    }

    final valid = int.parse(remainder) % 97 == 1;

    return RuleValidationResult(
      valid: valid,
      message: valid ? '' : 'IBAN is not in the correct format.',
    );
  }
}
