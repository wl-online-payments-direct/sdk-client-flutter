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

import '../../domain/payment_context.dart';

/// In-memory cache for SDK service responses.
class CacheManager {
  final Map<String, dynamic> _cache = {};

  /// Creates a unique cache key based on [context] and an optional [prefix]/[suffix].
  String createCacheKeyFromContext({
    required String prefix,
    required PaymentContext context,
    String? suffix,
  }) {
    final parts = [
      context.amountOfMoney.amount.toString(),
      context.countryCode,
      context.isRecurring.toString(),
      context.amountOfMoney.currencyCode,
      if (suffix != null && suffix.isNotEmpty) suffix,
    ];
    return '$prefix-${parts.join('_')}';
  }

  bool has(String key) => _cache.containsKey(key);

  T? get<T>(String key) => _cache[key] as T?;

  void set<T>(String key, T value) => _cache[key] = value;
}
