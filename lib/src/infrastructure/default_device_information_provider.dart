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

import 'dart:io' show Platform;

import 'interfaces/device_information_provider.dart';
import 'models/metadata.dart';

const _sdkVersion = '3.0.0';
const _sdkIdentifier = 'FlutterClientSDK/v$_sdkVersion';
const _sdkCreator = 'Online Payments';

/// Default Flutter implementation of [DeviceInformationProvider].
///
/// Uses [dart:io] Platform info for operating system details.
/// Screen size is not available without a BuildContext and is left empty.
class DefaultDeviceInformationProvider implements DeviceInformationProvider {
  final String? _osOverride;

  const DefaultDeviceInformationProvider({
    /// For testing only — overrides [Platform.operatingSystem].
    String? osOverride,
  }) : _osOverride = osOverride;

  @override
  Metadata getMetadata() {
    final os = _osOverride ?? Platform.operatingSystem;
    final osVersion = Platform.operatingSystemVersion;
    final platformIdentifier = '$os/$osVersion';
    final deviceBrand = _deviceBrand(os);

    return Metadata(
      screenSize: '',
      platformIdentifier: platformIdentifier,
      sdkIdentifier: _sdkIdentifier,
      sdkCreator: _sdkCreator,
      appIdentifier: '',
      deviceBrand: deviceBrand,
      deviceType: os,
    );
  }

  static String _deviceBrand(String os) {
    switch (os) {
      case 'ios':
      case 'macos':
        return 'Apple';
      default:
        return os;
    }
  }
}
