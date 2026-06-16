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

import '../../../infrastructure/utils/formatter.dart';
import '../../validation/validation_error_message.dart';
import 'data_restrictions.dart';
import 'payment_product_field_type.dart';
import 'product_field_display_hints.dart';

/// Represents a PaymentProductField object.
class PaymentProductField implements Comparable<PaymentProductField> {
  final String id;
  final PaymentProductFieldType type;
  final DataRestrictions dataRestrictions;
  final ProductFieldDisplayHints? displayHints;

  PaymentProductField(
    this.id,
    this.type, {
    this.displayHints = const ProductFieldDisplayHints.empty(),
    this.dataRestrictions = const DataRestrictions.empty(),
  });

  String getLabel() => displayHints?.label ?? id;

  String? getPlaceholder() => displayHints?.placeholderLabel;

  bool isRequired() => dataRestrictions.isRequired;

  int getDisplayOrder() => displayHints?.displayOrder ?? 0;

  bool shouldObfuscate() => displayHints?.obfuscate ?? false;

  /// Applies the field's display mask to [value].
  /// Returns [value] unchanged when the field has no mask.
  String? applyMask(String? value) {
    final mask = displayHints?.mask;

    return mask != null ? Formatter.applyMask(mask, value) : value;
  }

  /// Strips mask characters from [value], returning only the raw input.
  String removeMask(String value) {
    return Formatter.removeMask(displayHints?.mask, applyMask(value));
  }

  /// Validates [value] against all rules in [dataRestrictions].
  ///
  /// Returns an empty list when the value is valid. When [value] is null or
  /// empty and the field [isRequired], a single "required" error is returned.
  List<ValidationErrorMessage> validate(String? value) {
    final errors = <ValidationErrorMessage>[];

    if (value != null && value.isNotEmpty) {
      for (final rule in dataRestrictions.validationRules) {
        final result = rule.validate(value);
        if (!result.valid) {
          errors.add(ValidationErrorMessage(
            errorMessage: result.message,
            paymentProductFieldId: id,
            rule: rule,
          ));
        }
      }
    } else if (dataRestrictions.isRequired) {
      errors.add(ValidationErrorMessage(
        errorMessage: 'Field is required.',
        paymentProductFieldId: id,
      ));
    }

    return errors;
  }

  @override
  int compareTo(PaymentProductField other) {
    final a = displayHints?.displayOrder;
    final b = other.displayHints?.displayOrder;
    if (a == null) return 1;
    if (b == null) return -1;
    return a.compareTo(b);
  }
}
