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

part 'payment_context.g.dart';

/// Contains information about a payment, like its [AmountOfMoney] and countryCode.
@JsonSerializable(
  explicitToJson: true,
)
class PaymentContext {
  @JsonKey(required: true)
  AmountOfMoney amountOfMoney;

  /// Country code of the Country where the transaction will take place, should match the <a href="https://www.iso.org/iso-3166-country-codes.html">ISO-3166-alpha-2 standard</a>.
  @JsonKey(required: true)
  String countryCode;

  @JsonKey(required: true)
  bool isRecurring;

  @JsonKey(required: true)
  bool forceBasicFlow;

  PaymentContext(this.amountOfMoney, this.countryCode, this.isRecurring,
      {this.forceBasicFlow = false});

  factory PaymentContext.fromJson(Map<String, dynamic> json) =>
      _$PaymentContextFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentContextToJson(this);

  PaymentContext copyWith(
      {AmountOfMoney? amountOfMoney,
      String? countryCode,
      bool? isRecurring,
      bool? forceBasicFlow}) {
    return PaymentContext(amountOfMoney ?? this.amountOfMoney,
        countryCode ?? this.countryCode, isRecurring ?? this.isRecurring,
        forceBasicFlow: forceBasicFlow ?? this.forceBasicFlow);
  }
}
