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

import '../errors/invalid_argument_error.dart';
import '../payment_product/product_field/payment_product_field.dart';
import '../payment_product/product_field/payment_product_field_type.dart';
import '../validation/validation_result.dart';

/// Wraps a [PaymentProductField] with its current value and provides validation.
class PaymentRequestField {
  String? _value;
  final PaymentProductField _field;
  final bool readOnly;

  PaymentRequestField(this._field, {this.readOnly = false});

  /// Sets the field value. The value is automatically unmasked before storing.
  /// Throws [InvalidArgumentError] if the field is read-only.
  PaymentRequestField setValue(String newValue) {
    if (readOnly) {
      throw InvalidArgumentError('Cannot write read-only field: ${_field.id}');
    }

    _value = newValue.isNotEmpty ? _field.removeMask(newValue) : null;

    return this;
  }

  String? getValue() => _value;

  /// Returns the masked value for display purposes.
  String? getMaskedValue() => _field.applyMask(_value);

  String getId() => _field.id;

  PaymentProductFieldType getType() => _field.type;

  bool isRequired() => _field.dataRestrictions.isRequired;

  String getLabel() => _field.getLabel();

  String? getPlaceholder() => _field.getPlaceholder();

  bool shouldObfuscate() => _field.shouldObfuscate();

  PaymentRequestField clearValue() {
    _value = null;

    return this;
  }

  /// Validates the current value against the field's data restrictions.
  ValidationResult validate() {
    final errors = _field.validate(_value);

    return errors.isEmpty ? const ValidationResult.valid() : ValidationResult(errors);
  }
}
