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
import OnlinePaymentsKit

class InitializeSessionRequest: Decodable {
    let clientSessionId: String
    let customerId: String
    let clientApiUrl: String
    let assetUrl: String
    let appIdentifier: String
    var loggingEnabled: Bool = false
    let sdkIdentifier: String

    private enum CodingKeys: String, CodingKey {
        case clientSessionId, customerId, clientApiUrl, assetUrl, appIdentifier, loggingEnabled, sdkIdentifier
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.clientSessionId = try container.decode(String.self, forKey: .clientSessionId)
        self.customerId = try container.decode(String.self, forKey: .customerId)
        self.clientApiUrl = try container.decode(String.self, forKey: .clientApiUrl)
        self.assetUrl = try container.decode(String.self, forKey: .assetUrl)
        self.appIdentifier = try container.decode(String.self, forKey: .appIdentifier)
        self.loggingEnabled = try container.decode(Bool.self, forKey: .loggingEnabled)
        self.sdkIdentifier = try container.decode(String.self, forKey: .sdkIdentifier)
    }
}
