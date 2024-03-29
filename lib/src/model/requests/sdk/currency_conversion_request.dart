/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2024 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import 'package:json_annotation/json_annotation.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

part 'currency_conversion_request.g.dart';

/// Request used to retrieve a [CurrencyConversion] from the API.
@JsonSerializable(explicitToJson: true)
class CurrencyConversionRequest {
  @JsonKey(required: true)
  final AmountOfMoney amountOfMoney;

  @JsonKey()
  String? partialCreditCardNumber;

  @JsonKey()
  int? paymentProductId;

  @JsonKey()
  String? token;

  CurrencyConversionRequest(this.amountOfMoney);

  CurrencyConversionRequest.withPartialCreditCardNumber(
      this.amountOfMoney, this.partialCreditCardNumber,
      {this.paymentProductId});
  CurrencyConversionRequest.withToken(this.amountOfMoney, this.token);

  factory CurrencyConversionRequest.fromJson(Map<String, dynamic> json) =>
      _$CurrencyConversionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyConversionRequestToJson(this);
}
