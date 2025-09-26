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
import 'package:online_payments_sdk/src/model/models.dart';

/// Interface for all listeners used for making calls to the API.
class ApiResponseInterface<T> {
  final void Function(T response) success;
  final void Function(ErrorResponse? apiError) error;
  final void Function(NativeException? exception) exception;

  ApiResponseInterface(this.success, this.error, this.exception);

  onSuccess(T response) => success(response);

  onApiError(ErrorResponse? apiError) => error(apiError);

  onException(NativeException? ex) => exception(ex);
}
