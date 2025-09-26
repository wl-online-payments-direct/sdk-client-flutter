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
import 'package:json_annotation/json_annotation.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/native/masking/masking_util.dart';
import 'package:online_payments_sdk/src/native/validation/validator.dart';

part 'payment_product_field.g.dart';

/// Represents a PaymentProductField object.
@JsonSerializable(explicitToJson: true)
class PaymentProductField implements Comparable {
  @JsonKey(required: true)
  final String id;

  @JsonKey(required: true)
  final PaymentProductFieldType type;

  @JsonKey()
  final PaymentProductFieldDisplayHints? displayHints;

  @JsonKey()
  final DataRestrictions dataRestrictions;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<ValidationErrorMessage> errorMessageIds = [];

  PaymentProductField(
    this.id,
    this.type, {
    this.displayHints = const PaymentProductFieldDisplayHints.empty(),
    this.dataRestrictions = const DataRestrictions.empty(),
  });

  factory PaymentProductField.fromJson(Map<String, dynamic> json) => _$PaymentProductFieldFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentProductFieldToJson(this);

  /// Returns a list of [ValidationErrorMessage] for the supplied [value].
  /// If the list is empty, you can assume that the supplied [value] is a valid value.
  Future<List<ValidationErrorMessage>> validateValue(String value, PaymentProduct paymentProduct) async {
    final errorMessages =
        await PaymentProductFieldValidator.validateValueForPaymentProductField(value, this, paymentProduct);
    errorMessageIds = errorMessages;
    return errorMessages;
  }

  /// Returns a list of [ValidationErrorMessage] for the field's value in the supplied [request].
  /// If the list is empty, you can assume that the field value is a valid value.
  Future<List<ValidationErrorMessage>> validateValueForPaymentRequest(
    PaymentRequest request,
  ) async {
    final errorMessages = await PaymentRequestValidator.validatePaymentProductFieldForPaymentRequest(id, request);
    errorMessageIds = errorMessages;
    return errorMessages;
  }

  /// Returns the masked [value] of the [PaymentProductField].
  Future<String> applyMask(String value) async {
    final maskedValue = await PaymentProductFieldMasker.applyMask(this, value);
    return maskedValue;
  }

  /// Returns the unmasked [value] of the [PaymentProductField].
  Future<String> removeMask(String value) async {
    final unmaskedValue = await PaymentProductFieldMasker.removeMask(this, value);
    return unmaskedValue;
  }

  @override
  int compareTo(other) {
    return displayHints?.displayOrder.compareTo(other.displayHints?.displayOrder) ?? 1;
  }
}
