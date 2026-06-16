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

import 'interfaces/device_information_provider.dart';
import 'models/metadata.dart';

const _sdkVersion = '3.0.0';
const _sdkIdentifier = 'FlutterClientSDK/v$_sdkVersion';
const _sdkCreator = 'Online Payments';

@JS('window.innerWidth')
external int get _windowInnerWidth;

@JS('window.innerHeight')
external int get _windowInnerHeight;

@JS('navigator.userAgent')
external String get _navigatorUserAgent;

/// Flutter Web implementation of [DeviceInformationProvider].
///
/// Uses browser APIs via [dart:js_interop] to collect screen size and
/// user agent, since [dart:io] is not available on the web platform.
class WebDeviceInformationProvider implements DeviceInformationProvider {
  const WebDeviceInformationProvider();

  @override
  Metadata getMetadata() {
    return Metadata(
      screenSize: '${_windowInnerWidth}x$_windowInnerHeight',
      platformIdentifier: _navigatorUserAgent,
      sdkIdentifier: _sdkIdentifier,
      sdkCreator: _sdkCreator,
      appIdentifier: '',
      deviceBrand: '',
      deviceType: 'web',
    );
  }
}
