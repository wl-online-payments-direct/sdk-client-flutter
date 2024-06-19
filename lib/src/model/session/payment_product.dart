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
import 'package:online_payments_sdk/online_payments_sdk.dart';

part 'payment_product.g.dart';

/// Represents a [BasicPaymentProduct] and its [PaymentProductField]s.
@JsonSerializable(explicitToJson: true)
class PaymentProduct extends BasicPaymentProduct {
  @JsonKey(required: true)
  List<PaymentProductField> fields;

  PaymentProduct(
    super.id,
    super.paymentMethod,
    super.paymentProductGroup,
    super.allowsRecurring,
    super.allowsTokenization,
    super.usesRedirectionTo3rdParty, {
    super.displayHintsList,
    super.accountsOnFile,
    super.paymentProduct302SpecificData,
    super.paymentProduct320SpecificData,
    this.fields = const [],
  }) {
    fields.sort();
  }

  factory PaymentProduct.fromJson(Map<String, dynamic> json) =>
      _$PaymentProductFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PaymentProductToJson(this);

  /// If found, returns the [PaymentProductField] corresponding with the provided [paymentProductFieldId].
  /// If not found, null is returned.
  PaymentProductField? getPaymentProductFieldById(
    String paymentProductFieldId,
  ) {
    for (PaymentProductField field in fields) {
      if (field.id == paymentProductFieldId) {
        return field;
      }
    }
    return null;
  }
}
