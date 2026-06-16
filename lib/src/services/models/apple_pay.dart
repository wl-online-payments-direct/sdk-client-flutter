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

/// Interface for Apple Pay availability checks.
///
/// Consumers must provide an implementation that returns [true] only when
/// Apple Pay is set up and available on the current device.
abstract class ApplePay {
  Future<bool> isApplePayAvailable();
}

/// Default [ApplePay] implementation that always returns [false].
///
/// Used when no Apple Pay implementation is injected, ensuring product 302
/// is safely filtered out on non-Apple platforms.
class DefaultApplePay implements ApplePay {
  const DefaultApplePay();

  @override
  Future<bool> isApplePayAvailable() async => false;
}
