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
import 'package:online_payments_sdk/src/infrastructure/utils/cache_manager.dart';

void main() {
  group('CacheManager.createCacheKeyFromContext', () {
    final baseContext = PaymentContext(AmountOfMoney(100, 'EUR'), 'NL', isRecurring: true);

    test('creates a cache key with prefix and context fields', () {
      final cacheManager = CacheManager();

      final key = cacheManager.createCacheKeyFromContext(prefix: 'payment', context: baseContext);

      expect(key, 'payment-100_NL_true_EUR');
    });

    test('includes suffix when provided', () {
      final cacheManager = CacheManager();

      final key = cacheManager.createCacheKeyFromContext(
        prefix: 'payment',
        context: baseContext,
        suffix: 'extra',
      );

      expect(key, 'payment-100_NL_true_EUR_extra');
    });

    test('omits empty suffix from key', () {
      final cacheManager = CacheManager();

      final key = cacheManager.createCacheKeyFromContext(
        prefix: 'payment',
        context: baseContext,
        suffix: '',
      );

      expect(key, 'payment-100_NL_true_EUR');
    });

    test('creates different keys for different contexts', () {
      final cacheManager = CacheManager();
      final otherContext = PaymentContext(AmountOfMoney(200, 'EUR'), 'NL', isRecurring: true);

      final key1 = cacheManager.createCacheKeyFromContext(prefix: 'payment', context: baseContext);
      final key2 = cacheManager.createCacheKeyFromContext(prefix: 'payment', context: otherContext);

      expect(key1, isNot(key2));
    });

    test('createCacheKeyFromContext_WhenIsRecurringIsFalse_IncludesFalseInKey', () {
      final cacheManager = CacheManager();
      final context = PaymentContext(AmountOfMoney(100, 'EUR'), 'NL', isRecurring: false);

      final key = cacheManager.createCacheKeyFromContext(prefix: 'test', context: context);

      expect(key, contains('false'));
    });

    test('createCacheKeyFromContext_IsRecurringTrueVsFalse_GeneratesDifferentKeys', () {
      final cacheManager = CacheManager();
      final trueContext = PaymentContext(AmountOfMoney(100, 'EUR'), 'NL', isRecurring: true);
      final falseContext = PaymentContext(AmountOfMoney(100, 'EUR'), 'NL', isRecurring: false);

      final trueKey = cacheManager.createCacheKeyFromContext(prefix: 'test', context: trueContext);
      final falseKey = cacheManager.createCacheKeyFromContext(prefix: 'test', context: falseContext);

      expect(trueKey, isNot(falseKey));
    });

    test('createCacheKeyFromContext_WhenAmountIsZero_IncludesZeroInKey', () {
      final cacheManager = CacheManager();
      final context = PaymentContext(AmountOfMoney(0, 'EUR'), 'NL');

      final key = cacheManager.createCacheKeyFromContext(prefix: 'test', context: context);

      expect(key, contains('0'));
    });

    test('createCacheKeyFromContext_AmountZeroVsNonzero_GeneratesDifferentKeys', () {
      final cacheManager = CacheManager();
      final zeroContext = PaymentContext(AmountOfMoney(0, 'EUR'), 'NL');
      final nonZeroContext = PaymentContext(AmountOfMoney(100, 'EUR'), 'NL');

      final zeroKey = cacheManager.createCacheKeyFromContext(prefix: 'test', context: zeroContext);
      final nonZeroKey = cacheManager.createCacheKeyFromContext(prefix: 'test', context: nonZeroContext);

      expect(zeroKey, isNot(nonZeroKey));
    });
  });

  group('CacheManager cache operations', () {
    test('returns false for unknown keys', () {
      final cacheManager = CacheManager();

      expect(cacheManager.has('non-existent'), isFalse);
    });

    test('stores and retrieves values', () {
      final cacheManager = CacheManager();
      const key = 'test-key';
      const value = {'test': 'test'};

      cacheManager.set(key, value);

      expect(cacheManager.has(key), isTrue);
      expect(cacheManager.get<Map<String, String>>(key), value);
    });

    test('returns null for missing keys', () {
      final cacheManager = CacheManager();

      expect(cacheManager.get<String>('missing-key'), isNull);
    });

    test('overwrites values for the same key', () {
      final cacheManager = CacheManager();
      const key = 'duplicate-key';

      cacheManager.set(key, 'first');
      cacheManager.set(key, 'second');

      expect(cacheManager.get<String>(key), 'second');
    });

    test('stores different value types', () {
      final cacheManager = CacheManager();

      cacheManager.set('string-key', 'test string');
      cacheManager.set('number-key', 42);
      cacheManager.set('object-key', const {'test': true});

      expect(cacheManager.get<String>('string-key'), 'test string');
      expect(cacheManager.get<int>('number-key'), 42);
      expect(cacheManager.get<Map<String, bool>>('object-key'), const {'test': true});
    });
  });
}
