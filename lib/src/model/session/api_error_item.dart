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
  String errorCode;

  @JsonKey(required: false)
  String? category;

  @Deprecated(
    "In a future release, this field will be removed. Use errorCode instead.",
  )
  @JsonKey(required: false)
  String code;

  @JsonKey(required: false)
  int? httpStatusCode;

  @JsonKey(required: false)
  String? id;

  @JsonKey(required: false)
  String message;

  @JsonKey(required: false)
  String? propertyName;

  @JsonKey(required: false)
  bool? retriable;

  @Deprecated(
    "In a future release, code will be removed from this constructor. This object should not be initialized, it is initialized automatically when returned from the API.",
  )
  ApiErrorItem({
    required this.errorCode,
    this.category,
    @Deprecated("In a future release, this field will be removed.")
    this.code = "This error does not contain a code",
    this.httpStatusCode,
    this.id,
    this.message = "This error does not contain a message",
    this.propertyName,
    this.retriable = true,
  });

  factory ApiErrorItem.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorItemFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorItemToJson(this);
}
