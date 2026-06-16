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
import 'package:online_payments_sdk/src/infrastructure/utils/url_util.dart';

void main() {
  group('UrlUtil.segmentsToPath', () {
    test('should join path segments with slashes', () {
      expect(UrlUtil.segmentsToPath(['a', 'b', 'c']), equals('a/b/c'));
    });

    test('should remove leading and trailing slashes from segments', () {
      expect(UrlUtil.segmentsToPath(['a/', '/b/', 'c']), equals('a/b/c'));
    });

    test('should handle empty segments', () {
      expect(UrlUtil.segmentsToPath([]), equals(''));
    });

    test('should handle single segment', () {
      expect(UrlUtil.segmentsToPath(['api']), equals('api'));
    });

    test('should handle segments with multiple slashes', () {
      expect(UrlUtil.segmentsToPath(['//a//', '//b//', '//c//']), equals('a/b/c'));
    });
  });

  group('UrlUtil.objectToQueryString', () {
    test('should convert map to query string', () {
      expect(UrlUtil.objectToQueryString({'a': '1', 'b': '2'}), equals('a=1&b=2'));
    });

    test('should filter out empty string values', () {
      expect(UrlUtil.objectToQueryString({'a': '1', 'b': '2', 'c': ''}), equals('a=1&b=2'));
    });

    test('should handle empty map', () {
      expect(UrlUtil.objectToQueryString({}), equals(''));
    });

    test('should handle string values', () {
      expect(UrlUtil.objectToQueryString({'key': 'value', 'another': 'test'}), equals('key=value&another=test'));
    });

    test('should URL encode special characters (spaces as +)', () {
      expect(UrlUtil.objectToQueryString({'test': 'value with spaces'}), equals('test=value+with+spaces'));
    });

    test('should URL encode equals sign in value', () {
      expect(UrlUtil.objectToQueryString({'filter': 'type=test'}), contains('filter=type%3Dtest'));
    });
  });

  group('UrlUtil.urlWithQueryString', () {
    test('should construct URL with query string', () {
      final result = UrlUtil.urlWithQueryString('https://example.com', {'a': '1', 'b': '2'});
      expect(result, equals('https://example.com?a=1&b=2'));
    });

    test('should return URL unchanged for empty map', () {
      final result = UrlUtil.urlWithQueryString('https://example.com', {});
      expect(result, equals('https://example.com'));
    });

    test('should construct URL with path and query string', () {
      final result = UrlUtil.urlWithQueryString('https://example.com/api/products', {'page': '1', 'limit': '10'});
      expect(result, equals('https://example.com/api/products?page=1&limit=10'));
    });

    test('should filter out empty string values in query string', () {
      final result = UrlUtil.urlWithQueryString('https://example.com', {'a': '1', 'c': '', 'd': ''});
      expect(result, equals('https://example.com?a=1'));
    });

    test('should encode special characters in query parameters', () {
      final result = UrlUtil.urlWithQueryString('https://example.com', {
        'query': 'hello world',
        'filter': 'type=test',
      });
      expect(result, contains('query=hello+world'));
      expect(result, contains('filter=type%3Dtest'));
    });
  });
}
