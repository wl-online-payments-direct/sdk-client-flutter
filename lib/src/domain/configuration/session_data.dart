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

/// Holds session data returned from the server-side SDK session creation.
class SessionData {
  final String customerId;

  final String assetUrl;

  final String clientSessionId;

  final String clientApiUrl;

  SessionData({
    required this.customerId,
    required this.assetUrl,
    required this.clientSessionId,
    required this.clientApiUrl,
  });
}
