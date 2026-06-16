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

import 'dart:js_interop';

import 'interfaces/collected_device_information_provider.dart';
import 'models/collected_device_information.dart';

@JS('Date')
extension type JSDate._(JSObject _) implements JSObject {
  external JSDate();

  external int getTimezoneOffset();
}

@JS('navigator.language')
external String get _navigatorLanguage;

@JS('screen.colorDepth')
external int get _screenColorDepth;

@JS('screen.height')
external int get _screenHeight;

@JS('screen.width')
external int get _screenWidth;

@JS('window.innerHeight')
external int get _windowInnerHeight;

@JS('window.innerWidth')
external int get _windowInnerWidth;

/// Flutter Web implementation of [CollectedDeviceInformationProvider].
///
/// Collects browser fingerprint data required for 3DS2 authentication via
/// [dart:js_interop]. Matches the data shape sent by the JavaScript SDK.
class WebCollectedDeviceInformationProvider implements CollectedDeviceInformationProvider {
  const WebCollectedDeviceInformationProvider();

  @override
  CollectedDeviceInformation? getCollectedDeviceInformation() {
    return CollectedDeviceInformation(
      timezoneOffsetUtcMinutes: JSDate().getTimezoneOffset(),
      locale: _navigatorLanguage,
      browserData: BrowserData(
        javaScriptEnabled: true,
        colorDepth: _screenColorDepth,
        screenHeight: _screenHeight,
        screenWidth: _screenWidth,
        innerHeight: _windowInnerHeight,
        innerWidth: _windowInnerWidth,
      ),
    );
  }
}
