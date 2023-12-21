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

part 'native_exception.g.dart';

/// Contains information about a native SDK error if it occurred while executing API calls.
@JsonSerializable(
    explicitToJson: true,
    includeIfNull: true,
    genericArgumentFactories: true
)
class NativeException {
  @JsonKey()
  String error = "";
  @JsonKey(includeFromJson: false, includeToJson: false)
  StackTrace? stackTrace;

  NativeException({this.error = "", this.stackTrace});
  static NativeException fromErrorResponse(ErrorResponse? errorResponse) {
    if (errorResponse == null) {
      return NativeException(error: "Native exception from Error Response, but errorResponse is null");
    }
    if (errorResponse.throwable != null) {
      return NativeException(error: "Native exception from Error Response with throwable.\nmessage: ${errorResponse.throwable?.message}\nthrowable: ${errorResponse.throwable?.throwable.toString()}\napiErrorId: ${errorResponse.apiError?.errorId}\napiErrorItems: ${errorResponse.apiError?.errors?.join(",")}");
    }
    return NativeException(error: "Native Exception from Error Response without throwable.\napiErrorId: ${errorResponse.apiError?.errorId}\napiErrorItems: ${errorResponse.apiError?.errors?.join(",")}");
  }

  static NativeException fromThrowable(Throwable? throwable) {
    if (throwable == null) {
      return NativeException(error: "Native exception from Throwable, but throwable is null");
    }
    return NativeException(error: "Native exception from Throwable.\nmessage: ${throwable.message}\nthrowable: ${throwable.throwable.toString()}");
  }

  factory NativeException.fromJson(Map<String, dynamic> json) => _$NativeExceptionFromJson(json);

  Map<String, dynamic> toJson() => _$NativeExceptionToJson(this);
}