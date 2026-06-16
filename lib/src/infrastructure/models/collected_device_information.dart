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

/// Browser-specific data collected for 3DS2 authentication on web.
class BrowserData {
  final bool javaScriptEnabled;
  final int colorDepth;
  final int screenHeight;
  final int screenWidth;
  final int innerHeight;
  final int innerWidth;

  const BrowserData({
    required this.javaScriptEnabled,
    required this.colorDepth,
    required this.screenHeight,
    required this.screenWidth,
    required this.innerHeight,
    required this.innerWidth,
  });

  Map<String, dynamic> toJson() => {
        'javaScriptEnabled': javaScriptEnabled,
        'colorDepth': colorDepth,
        'screenHeight': screenHeight,
        'screenWidth': screenWidth,
        'innerHeight': innerHeight,
        'innerWidth': innerWidth,
      };
}

/// Device/browser information collected for 3DS2 authentication.
///
/// On web this includes browser fingerprint data. On mobile this is not collected.
class CollectedDeviceInformation {
  final int timezoneOffsetUtcMinutes;
  final String locale;
  final BrowserData browserData;

  const CollectedDeviceInformation({
    required this.timezoneOffsetUtcMinutes,
    required this.locale,
    required this.browserData,
  });

  Map<String, dynamic> toJson() => {
        'timezoneOffsetUtcMinutes': timezoneOffsetUtcMinutes,
        'locale': locale,
        'browserData': browserData.toJson(),
      };
}
