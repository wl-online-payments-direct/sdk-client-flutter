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
part of '../session.dart';

class _NativeFutureInterface<T> {
  late void Function(T response) onSuccess;
  late void Function(ErrorResponse? apiError) onApiError;
  late void Function(NativeException? e) onException;
  // Use in case you want to add stuff before/after call the api listener (calling api listener needs to be done manually)
  _NativeFutureInterface(
      {required this.onSuccess,
      required this.onApiError,
      required this.onException});
  // Use for simple bridge between NativeFutureListener and ApiResponseListener
  _NativeFutureInterface.fromListener(ApiResponseInterface<T> listener) {
    onSuccess = (response) {
      listener.onSuccess(response);
    };
    onApiError = (apiError) {
      listener.onApiError(apiError);
    };
    onException = (e) {
      listener.onException(e);
    };
  }
}
