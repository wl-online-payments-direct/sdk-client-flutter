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

import 'card.dart';

/// Represents a card source that can be either a [Card] or a token string.
sealed class CardSource {
  const CardSource();
}

class CardSourceWithCard extends CardSource {
  final Card card;

  const CardSourceWithCard(this.card);
}

class CardSourceWithToken extends CardSource {
  final String token;

  const CardSourceWithToken(this.token);
}
