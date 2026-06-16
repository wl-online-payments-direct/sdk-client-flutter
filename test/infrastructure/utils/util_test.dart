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

import 'package:flutter_test/flutter_test.dart';
import 'package:online_payments_sdk/src/infrastructure/interfaces/device_information_provider.dart';
import 'package:online_payments_sdk/src/infrastructure/models/metadata.dart';
import 'package:online_payments_sdk/src/infrastructure/utils/util.dart';

class _FakeDeviceInformationProvider implements DeviceInformationProvider {
  @override
  Metadata getMetadata() => const Metadata(
        screenSize: '',
        platformIdentifier: 'test-platform',
        sdkIdentifier: 'test-sdk',
        sdkCreator: 'test-creator',
        appIdentifier: '',
        deviceBrand: 'test-brand',
        deviceType: 'test-device',
      );
}

void main() {
  group('Util.getMetadata', () {
    test('getMetadata_WithAppIdentifier_OverridesAppIdentifierInReturnedMetadata', () {
      final metadata = Util.getMetadata(
        provider: _FakeDeviceInformationProvider(),
        appIdentifier: 'custom-app',
      );

      expect(metadata.appIdentifier, equals('custom-app'));
    });

    test('getMetadata_WithoutAppIdentifier_ReturnsMetadataFromProvider', () {
      final metadata = Util.getMetadata(
        provider: _FakeDeviceInformationProvider(),
      );

      expect(metadata.appIdentifier, isEmpty);
      expect(metadata.sdkIdentifier, equals('test-sdk'));
    });
  });

  group('Util.base64UrlEncode', () {
    test('base64UrlEncode_WithString_ReturnsBase64UrlEncodedWithoutPadding', () {
      final result = Util.base64UrlEncode('hello world');

      expect(result, isNot(contains('=')));
      final decoded = utf8.decode(base64Url.decode(base64Url.normalize(result)));
      expect(decoded, equals('hello world'));
    });
  });
}
