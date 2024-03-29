/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2023 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/masker.dart';
import 'package:online_payments_sdk/src/validator.dart';

part 'payment_request.g.dart';

/// Contains all data required for creating a payment.
@JsonSerializable(explicitToJson: true)
class PaymentRequest {
  @JsonKey(required: true)
  PaymentProduct paymentProduct;
  @JsonKey(required: false)
  AccountOnFile? accountOnFile;
  Map<String, String> fieldValues = {};
  List<ValidationErrorMessage> errorMessageIds = [];
  @JsonKey(required: true)
  bool tokenize = false;

  PaymentRequest(
      {required this.paymentProduct,
      this.tokenize = false,
      this.accountOnFile});

  factory PaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentRequestToJson(this);

  /// Validates all fields based on their value and their validation rules.
  /// If a field is prefilled from the [AccountOnFile], but it has been altered, it will be validated.
  /// Returns a list of [ValidationErrorMessage].
  Future<List<ValidationErrorMessage>> validate() async {
    final errorMessages =
        await PaymentRequestValidator.validatePaymentRequest(this);
    errorMessageIds = errorMessages;
    return errorMessages;
  }

  /// Sets the [value] for the [PaymentProductField] corresponding with the [paymentProductFieldId].
  setValue(String paymentProductFieldId, String value) {
    fieldValues.remove(paymentProductFieldId);
    fieldValues[paymentProductFieldId] = value;
  }

  /// Removes the value from the [PaymentProductField] corresponding with the [paymentProductFieldId].
  removeValue(String paymentProductFieldId) {
    fieldValues.remove(paymentProductFieldId);
  }

  /// Returns the value of the [PaymentProductField] corresponding with the [paymentProductFieldId].
  String? getValue(String paymentProductFieldId) {
    return fieldValues[paymentProductFieldId];
  }

  /// Returns the masked value for the given payment product [fieldId].
  Future<String> getMaskedValue(String fieldId) async {
    final maskedValue =
        await PaymentProductRequestMasker.maskedValue(this, fieldId);
    return maskedValue;
  }

  /// Returns the unmasked value for the given payment product [fieldId].
  Future<String> getUnmaskedValue(String fieldId) async {
    final unmaskedValue =
        await PaymentProductRequestMasker.unmaskedValue(this, fieldId);
    return unmaskedValue;
  }

  /// Returns a Map of a payment product field id and the corresponding masked value
  Future<Map<String, String>> getMaskedValues() async {
    final allMaskedValuesString =
        await PaymentProductRequestMasker.maskedValues(this);
    if (allMaskedValuesString != null) {
      final Map<String, String> allMaskedValuesMap =
          Map.castFrom(json.decode(allMaskedValuesString));
      return allMaskedValuesMap;
    }
    return <String, String>{};
  }

  /// Returns a Map of a payment product field id and the corresponding unmasked value
  Future<Map<String, String>> getUnmaskedValues() async {
    final allUnmaskedValuesString =
        await PaymentProductRequestMasker.unmaskedValues(this);
    if (allUnmaskedValuesString != null) {
      final Map<String, String> allUnmaskedValuesMap =
          Map.castFrom(json.decode(allUnmaskedValuesString));
      return allUnmaskedValuesMap;
    }
    return <String, String>{};
  }

  /// Merges existing field values map with the [paymentProduct] values.
  mergePaymentRequest({required PaymentProduct paymentProduct}) {
    Map<String, String> newFieldValues = {};
    for (PaymentProductField field in paymentProduct.fields) {
      for (MapEntry<String, String> fieldValue in fieldValues.entries) {
        if (field.id == fieldValue.key) {
          newFieldValues[fieldValue.key] = fieldValue.value;
        }
      }
    }
    return newFieldValues;
  }
}
