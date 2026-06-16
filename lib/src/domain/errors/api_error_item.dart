/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2026 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */

/// If an API error occurred during an API call, this object might be available on [ApiError] and contains more information about the error that occurred.
class ApiErrorItem {
  String errorCode;

  String? category;

  int? httpStatusCode;

  String? id;

  String message;

  String? propertyName;

  bool? retriable;

  ApiErrorItem({
    required this.errorCode,
    this.category,
    this.httpStatusCode,
    this.id,
    this.message = 'This error does not contain a message',
    this.propertyName,
    this.retriable = true,
  });

  factory ApiErrorItem.fromJson(Map<String, dynamic> json) => ApiErrorItem(
        errorCode: json['errorCode'] as String? ?? '',
        category: json['category'] as String?,
        httpStatusCode: (json['httpStatusCode'] as num?)?.toInt(),
        id: json['id'] as String?,
        message: json['message'] as String? ?? 'This error does not contain a message',
        propertyName: json['propertyName'] as String?,
        retriable: json['retriable'] as bool?,
      );
}
