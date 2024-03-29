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

part 'throwable.g.dart';

/// Object that contains more information if an API call failed due to a non-API related error.
@JsonSerializable(explicitToJson: true)
class Throwable {
  @JsonKey(required: false, defaultValue: null)
  String? message;

  @JsonKey(required: false, defaultValue: null)
  Throwable? throwable;

  Throwable(this.message, {required this.throwable});

  factory Throwable.fromJson(Map<String, dynamic> json) =>
      _$ThrowableFromJson(json);

  Map<String, dynamic> toJson() => _$ThrowableToJson(this);
}
