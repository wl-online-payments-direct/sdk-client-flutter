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

import 'package:flutter_test/flutter_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/facade/session_data_normalizer.dart';

SessionData _validSessionData() {
  return SessionData(
    customerId: 'customer123',
    assetUrl: 'https://assets.example.com',
    clientSessionId: 'session456',
    clientApiUrl: 'https://api.example.com/client',
  );
}

void main() {
  group('normalizeSessionData', () {
    test('throws when customerId is empty', () {
      final sessionData = SessionData(
        customerId: '',
        assetUrl: 'https://assets.example.com',
        clientSessionId: 'session456',
        clientApiUrl: 'https://api.example.com/client',
      );

      expect(
        () => normalizeSessionData(sessionData),
        throwsA(
          isA<ConfigurationError>().having(
            (error) => error.message,
            'message',
            "The SessionData parameter 'customerId' is mandatory.",
          ),
        ),
      );
    });

    test('throws when assetUrl is empty', () {
      final sessionData = SessionData(
        customerId: 'customer123',
        assetUrl: '',
        clientSessionId: 'session456',
        clientApiUrl: 'https://api.example.com/client',
      );

      expect(() => normalizeSessionData(sessionData), throwsA(isA<ConfigurationError>()));
    });

    test('throws when clientSessionId is empty', () {
      final sessionData = SessionData(
        customerId: 'customer123',
        assetUrl: 'https://assets.example.com',
        clientSessionId: '',
        clientApiUrl: 'https://api.example.com/client',
      );

      expect(() => normalizeSessionData(sessionData), throwsA(isA<ConfigurationError>()));
    });

    test('throws when clientApiUrl is empty', () {
      final sessionData = SessionData(
        customerId: 'customer123',
        assetUrl: 'https://assets.example.com',
        clientSessionId: 'session456',
        clientApiUrl: '',
      );

      expect(() => normalizeSessionData(sessionData), throwsA(isA<ConfigurationError>()));
    });

    test('throws when clientApiUrl is invalid', () {
      final sessionData = SessionData(
        customerId: 'customer123',
        assetUrl: 'https://assets.example.com',
        clientSessionId: 'session456',
        clientApiUrl: 'not-a-valid-url',
      );

      expect(
        () => normalizeSessionData(sessionData),
        throwsA(isA<ConfigurationError>().having((error) => error.message, 'message', contains('clientApiUrl'))),
      );
    });

    test('throws when clientApiUrl has an unexpected path', () {
      final sessionData = SessionData(
        customerId: 'customer123',
        assetUrl: 'https://assets.example.com',
        clientSessionId: 'session456',
        clientApiUrl: 'https://api.example.com/wrong/path',
      );

      expect(
        () => normalizeSessionData(sessionData),
        throwsA(isA<ConfigurationError>().having((error) => error.message, 'message', contains('/wrong/path'))),
      );
    });

    test('throws when clientApiUrl has multiple path segments', () {
      final sessionData = SessionData(
        customerId: 'customer123',
        assetUrl: 'https://assets.example.com',
        clientSessionId: 'session456',
        clientApiUrl: 'https://api.example.com/client/extra',
      );

      expect(() => normalizeSessionData(sessionData), throwsA(isA<ConfigurationError>()));
    });

    test('adds /client when clientApiUrl has no path', () {
      final sessionData = SessionData(
        customerId: 'customer123',
        assetUrl: 'https://assets.example.com',
        clientSessionId: 'session456',
        clientApiUrl: 'https://api.example.com',
      );

      final result = normalizeSessionData(sessionData);

      expect(result.clientApiUrl, 'https://api.example.com/client');
    });

    test('keeps a valid /client path', () {
      final result = normalizeSessionData(_validSessionData());

      expect(result.clientApiUrl, 'https://api.example.com/client');
    });

    test('strips trailing slash from /client/ path', () {
      final sessionData = SessionData(
        customerId: 'customer123',
        assetUrl: 'https://assets.example.com',
        clientSessionId: 'session456',
        clientApiUrl: 'https://api.example.com/client/',
      );

      final result = normalizeSessionData(sessionData);

      expect(result.clientApiUrl, 'https://api.example.com/client');
    });

    test('returns a normalized copy', () {
      final sessionData = _validSessionData();
      final result = normalizeSessionData(sessionData);

      expect(result.customerId, 'customer123');
      expect(result.assetUrl, 'https://assets.example.com');
      expect(result.clientSessionId, 'session456');
      expect(result.clientApiUrl, 'https://api.example.com/client');
      expect(identical(result, sessionData), isFalse);
    });

    test('does not mutate the original SessionData object', () {
      final sessionData = _validSessionData();

      normalizeSessionData(sessionData);

      expect(sessionData.customerId, 'customer123');
      expect(sessionData.assetUrl, 'https://assets.example.com');
      expect(sessionData.clientSessionId, 'session456');
      expect(sessionData.clientApiUrl, 'https://api.example.com/client');
    });
  });
}
