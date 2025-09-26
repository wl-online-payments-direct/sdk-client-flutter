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

import 'api_response_listener_interface.dart';

/// Listener used when retrieving a [IinDetailsResponse] from the API.
final class IinLookupResponseListener extends ApiResponseInterface<IinDetailsResponse> {
  IinLookupResponseListener({
    required void Function(IinDetailsResponse response) onSuccess,
    required void Function(ErrorResponse? apiError) onError,
    required void Function(NativeException? exception) onException,
  }) : super(onSuccess, onError, onException);
}
