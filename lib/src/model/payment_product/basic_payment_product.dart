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

part 'basic_payment_product.g.dart';

/// Represents a BasicPaymentProduct object.
@JsonSerializable(explicitToJson: true)
class BasicPaymentProduct implements Comparable {
  @JsonKey()
  final String id;

  @JsonKey()
  final String paymentMethod;

  @JsonKey()
  final String? paymentProductGroup;

  @JsonKey()
  final bool allowsRecurring;

  @JsonKey()
  final bool allowsTokenization;

  @JsonKey()
  final bool usesRedirectionTo3rdParty;

  @JsonKey()
  final List<PaymentProductDisplayHints> displayHintsList;

  @JsonKey()
  final List<AccountOnFile> accountsOnFile;

  @JsonKey()
  final PaymentProduct302SpecificData? paymentProduct302SpecificData;

  @JsonKey()
  final PaymentProduct320SpecificData? paymentProduct320SpecificData;

  BasicPaymentProduct(
    this.id,
    this.paymentMethod,
    this.paymentProductGroup,
    this.allowsRecurring,
    this.allowsTokenization,
    this.usesRedirectionTo3rdParty, {
    this.displayHintsList = const [],
    this.accountsOnFile = const [],
    this.paymentProduct320SpecificData,
    this.paymentProduct302SpecificData,
  });

  factory BasicPaymentProduct.fromJson(Map<String, dynamic> json) =>
      _$BasicPaymentProductFromJson(json);

  Map<String, dynamic> toJson() => _$BasicPaymentProductToJson(this);

  @override
  int compareTo(other) {
    if (displayHintsList.isEmpty) {
      return other.displayHintsList.isEmpty ? 0 : -1;
    }
    return displayHintsList[0]
        .displayOrder
        .compareTo(other.displayHintsList[0]?.displayOrder);
  }
}
