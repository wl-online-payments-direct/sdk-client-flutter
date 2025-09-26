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

part 'api_error.g.dart';

/// If an API error occurred during an API call, this object might be available on [ErrorResponse] and contains more information about the error that occurred.
@JsonSerializable(explicitToJson: true)
class ApiError {
  @JsonKey(required: true)
  String errorId;

  @JsonKey(required: true)
  List<ApiErrorItem>? errors;

  ApiError(this.errorId, {required this.errors});

  factory ApiError.fromJson(Map<String, dynamic> json) => _$ApiErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);
}
