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

import 'dart:convert';

import '../interfaces/device_information_provider.dart';
import '../models/metadata.dart';

/// General-purpose utility functions for the SDK infrastructure layer.
class Util {
  Util._();

  /// Builds a [Metadata] object by calling [provider] and overriding [appIdentifier] if provided.
  static Metadata getMetadata({
    required DeviceInformationProvider provider,
    String? appIdentifier,
  }) {
    final metadata = provider.getMetadata();
    if (appIdentifier == null || appIdentifier.isEmpty) return metadata;

    return Metadata(
      screenSize: metadata.screenSize,
      platformIdentifier: metadata.platformIdentifier,
      sdkIdentifier: metadata.sdkIdentifier,
      sdkCreator: metadata.sdkCreator,
      appIdentifier: appIdentifier,
      deviceBrand: metadata.deviceBrand,
      deviceType: metadata.deviceType,
    );
  }

  /// Encodes [data] as a base64url string (no padding, RFC 4648 §5).
  static String base64UrlEncode(String data) {
    final bytes = utf8.encode(data);
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}
