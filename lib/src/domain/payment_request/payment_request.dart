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

import '../account_on_file/account_on_file.dart';
import '../errors/invalid_argument_error.dart';
import '../payment_product/product_field/payment_product_field.dart';
import '../payment_product/payment_product.dart';
import '../validation/validation_error_message.dart';
import '../validation/validation_result.dart';
import 'payment_request_field.dart';

/// Contains all data required for creating a payment.
class PaymentRequest {
  final PaymentProduct paymentProduct;
  List<ValidationErrorMessage> errorMessageIds = [];
  bool tokenize = false;

  AccountOnFile? _accountOnFile;

  final Map<String, PaymentRequestField> _fields = {};

  PaymentRequest({
    required this.paymentProduct,
    this.tokenize = false,
    AccountOnFile? accountOnFile,
  }) : _accountOnFile = accountOnFile;

  AccountOnFile? get accountOnFile => _accountOnFile;

  set accountOnFile(AccountOnFile? newAof) {
    if (newAof != null) {
      _fields.removeWhere((fieldId, _) => !newAof.isWritable(fieldId));
    }
    _accountOnFile = newAof;
  }

  /// Returns the [PaymentRequestField] for [fieldId], creating it lazily.
  /// Throws [InvalidArgumentError] if the field is not found in the payment product.
  PaymentRequestField getField(String fieldId) {
    final readOnly = _accountOnFile != null && !_accountOnFile!.isWritable(fieldId);

    if (_fields[fieldId] == null) {
      final definition = paymentProduct.getField(fieldId);

      if (definition == null) {
        throw InvalidArgumentError("Field '$fieldId' not found in payment product");
      }

      _fields[fieldId] = PaymentRequestField(definition, readOnly: readOnly);
    }

    return _fields[fieldId]!;
  }

  /// Returns all raw (unmasked) field values.
  Map<String, String> getValues() {
    final result = <String, String>{};

    for (final entry in _fields.entries) {
      final value = entry.value.getValue();
      if (value != null) {
        result[entry.key] = value;
      }
    }

    return result;
  }

  /// Validates all fields based on their value and their validation rules.
  /// If a field is prefilled from the [AccountOnFile] as read-only, it is skipped.
  /// If a field is prefilled but has been altered by the user, it will be validated.
  ValidationResult validate() {
    final errors = <ValidationErrorMessage>[];

    if (_accountOnFile != null) {
      final requiredAttributes = _accountOnFile!.getRequiredAttributes();

      final fieldsToValidate = paymentProduct.fields.where((field) {
        final userValue = getValue(field.id);

        if (_accountOnFile!.getAttribute(field.id) == null) {
          return true;
        }

        final isMustWrite = requiredAttributes.any((a) => a.key == field.id);

        return isMustWrite || userValue != null;
      }).toList();

      _validateFields(fieldsToValidate, errors);
    } else {
      _validateFields(paymentProduct.fields, errors);
    }

    errorMessageIds = errors;

    return errors.isEmpty ? const ValidationResult.valid() : ValidationResult(errors);
  }

  void _validateFields(List<PaymentProductField> fields, List<ValidationErrorMessage> errors) {
    for (final fieldDefinition in fields) {
      final result = getField(fieldDefinition.id).validate();
      errors.addAll(result.errorMessages);
    }
  }

  /// Sets the [value] for the field with [fieldId].
  /// The value is automatically unmasked before storing.
  void setValue(String fieldId, String value) {
    getField(fieldId).setValue(value);
  }

  /// Removes the value from the field with [fieldId].
  void removeValue(String fieldId) {
    _fields[fieldId]?.clearValue();
  }

  /// Returns the raw (unmasked) value for the field with [fieldId].
  String? getValue(String fieldId) {
    return _fields[fieldId]?.getValue();
  }

  /// Merges existing field values with the [paymentProduct] fields,
  /// returning only values that exist in both.
  Map<String, String> mergePaymentRequest({required PaymentProduct paymentProduct}) {
    final currentValues = getValues();
    final result = <String, String>{};

    for (final field in paymentProduct.fields) {
      final value = currentValues[field.id];
      if (value != null) {
        result[field.id] = value;
      }
    }

    return result;
  }
}
