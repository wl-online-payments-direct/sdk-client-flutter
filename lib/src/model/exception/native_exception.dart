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

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

part 'native_exception.g.dart';

/// Contains information about a native SDK error if it occurred while executing API calls.
@JsonSerializable(
  explicitToJson: true,
  includeIfNull: true,
  genericArgumentFactories: true,
)
class NativeException {
  @JsonKey()
  String error = "";

  @JsonKey()
  Throwable? throwable;

  NativeException({
    this.error = "",
    this.throwable,
  });

  static NativeException fromThrowable(Throwable? throwable) {
    return NativeException(
        error:
            "Native exception from Throwable.\nMessage: ${throwable?.message ?? ""}.\nThrowable: ${jsonEncode(throwable?.throwable?.toJson())}",
        throwable: throwable);
  }

  factory NativeException.fromJson(Map<String, dynamic> json) => _$NativeExceptionFromJson(json);

  Map<String, dynamic> toJson() => _$NativeExceptionToJson(this);
}
