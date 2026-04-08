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
import Flutter

internal extension Encodable {
    func forwardResultAsString(encodingErrorType: EncodingErrorType, result: FlutterResult) {
        guard let valueEncoded = try? JSONEncoder().encode(self),
              let valueAsString = String(data: valueEncoded, encoding: .utf8) else {
            result(ResultError.encodingError(type: encodingErrorType))
            return
        }
        result(valueAsString)
    }
}
