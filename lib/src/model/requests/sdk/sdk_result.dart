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

part 'sdk_result.g.dart';

/// Result returned from the native SDKs after a call to the API was made.
/// If successful, SdkResult contains the returned data. If not successful, SdkResult contains an [ErrorResponse].
@JsonSerializable(explicitToJson: true, genericArgumentFactories: true)
class SdkResult<T> {
  @JsonKey(required: false)
  T? data;

  @JsonKey(required: false)
  ErrorResponse? error;

  @JsonKey(required: false)
  Throwable? throwable;

  SdkResult(this.data, this.error, {this.throwable});

  factory SdkResult.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$SdkResultFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$SdkResultToJson(this, toJsonT);

  SdkResultStatus status() {
    if (data != null && error == null) {
      return SdkResultStatus.success;
    } else if (error != null) {
      if (error?.throwable != null) {
        return SdkResultStatus.exception;
      } else {
        return SdkResultStatus.apiError;
      }
    } else {
      // no data and no error
      return SdkResultStatus.exception;
    }
  }
}
