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

/// Device and SDK metadata sent in the X-GCS-ClientMetaInfo header with every API request.
class Metadata {
  final String screenSize;
  final String platformIdentifier;
  final String sdkIdentifier;
  final String sdkCreator;
  final String appIdentifier;
  final String deviceBrand;
  final String deviceType;

  const Metadata({
    required this.screenSize,
    required this.platformIdentifier,
    required this.sdkIdentifier,
    required this.sdkCreator,
    required this.appIdentifier,
    required this.deviceBrand,
    required this.deviceType,
  });

  Map<String, dynamic> toJson() => {
        'screenSize': screenSize,
        'platformIdentifier': platformIdentifier,
        'sdkIdentifier': sdkIdentifier,
        'sdkCreator': sdkCreator,
        'appIdentifier': appIdentifier,
        'deviceBrand': deviceBrand,
        'deviceType': deviceType,
      };
}
