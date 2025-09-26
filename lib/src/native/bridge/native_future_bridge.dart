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

import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/native/bridge/native_future_interface.dart';

class NativeFuture<T> {
  final Future<String> _job;
  final T Function(Object?) _fromJson;
  final NativeFutureInterface<T> _listener;

  NativeFuture(this._job, this._fromJson, this._listener);

  awaitJob() async {
    return await _job.then(
      (value) {
        final result = _parseResult(value);
        final resultStatus = result.status();
        switch (resultStatus) {
          case SdkResultStatus.success:
            final data = result.data;
            data == null
                ? _listener.onException(
                    NativeException.fromThrowable(
                      Throwable(
                        "No data available for successful call",
                        throwable: null,
                      ),
                    ),
                  )
                : _listener.onSuccess(data);
          case SdkResultStatus.apiError:
            _listener.onApiError(result.error);
          case SdkResultStatus.exception:
            _listener.onException(
              NativeException.fromThrowable(
                result.throwable ??
                    Throwable(
                      "Exception status without throwable",
                      throwable: null,
                    ),
              ),
            );
        }
      },
    ).onError(
      (error, stackTrace) {
        _listener.onException(
          NativeException.fromThrowable(
            Throwable(
              error.toString(),
              throwable: Throwable(
                stackTrace.toString(),
                throwable: null,
              ),
            ),
          ),
        );
      },
    );
  }

  SdkResult<T> _parseResult(String response) {
    Map<String, dynamic> json = jsonDecode(response);
    final result = SdkResult<T>.fromJson(json, _fromJson);
    return result;
  }
}
