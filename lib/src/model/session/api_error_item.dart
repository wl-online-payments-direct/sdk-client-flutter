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

part 'api_error_item.g.dart';

/// If an API error occurred during an API call, this object might be available on [ApiError] and contains more information about the error that occurred.
@JsonSerializable(explicitToJson: true)
class ApiErrorItem {
  @JsonKey(required: true)
  String code;

  @JsonKey(required: true)
  String message;

  ApiErrorItem(this.code, this.message);

  factory ApiErrorItem.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorItemFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorItemToJson(this);
}
