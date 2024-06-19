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

part 'iin_details_response.g.dart';

/// Represents a IinDetailsResponse object.
@JsonSerializable(
  explicitToJson: true,
)
class IinDetailsResponse {
  @JsonKey(required: true)
  final IinStatus status;

  @JsonKey()
  final String? paymentProductId;

  @JsonKey()
  final String? countryCode;

  @JsonKey()
  final bool isAllowedInContext;

  @JsonKey()
  final List<IinDetail> coBrands;

  @JsonKey(required: true)
  final CardType cardType;

  IinDetailsResponse(
    this.status,
    this.cardType, {
    required this.paymentProductId,
    required this.countryCode,
    required this.isAllowedInContext,
    this.coBrands = const [],
  });

  factory IinDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$IinDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IinDetailsResponseToJson(this);
}
