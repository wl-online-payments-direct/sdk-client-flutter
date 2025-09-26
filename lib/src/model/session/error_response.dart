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

part 'error_response.g.dart';

/// Object that contains more information if an API call failed due to an API related error.
@JsonSerializable(explicitToJson: true)
class ErrorResponse {
  /// The error message.
  @JsonKey(required: true)
  String message;

  /// The error from the API, if this was made available from the API.
  @JsonKey(required: false, defaultValue: null)
  ApiError? apiError;

  /// The exception that has occurred.
  @JsonKey(required: false, defaultValue: null)
  Throwable? throwable;

  ErrorResponse(this.message, {this.apiError, this.throwable});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}
