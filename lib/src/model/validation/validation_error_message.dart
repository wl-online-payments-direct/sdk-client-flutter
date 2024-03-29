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

part 'validation_error_message.g.dart';

/// Contains error message information for a specific [PaymentProductField].
@JsonSerializable()
class ValidationErrorMessage {
  final String errorMessage;
  final String paymentProductFieldId;
  final ValidationRule? rule;

  ValidationErrorMessage(
      {required this.errorMessage,
      required this.paymentProductFieldId,
      this.rule});

  factory ValidationErrorMessage.fromJson(Map<String, dynamic> json) =>
      _$ValidationErrorMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ValidationErrorMessageToJson(this);
}
