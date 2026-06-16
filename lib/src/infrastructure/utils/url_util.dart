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

/// Utility class for building API URLs.
class UrlUtil {
  UrlUtil._();

  /// Joins [segments] into a URL path, stripping leading/trailing slashes from each segment.
  static String segmentsToPath(List<String> segments) {
    return segments.map((s) => s.replaceAll(RegExp(r'^\/+|\/+$'), '')).where((s) => s.isNotEmpty).join('/');
  }

  /// Converts a [params] map into a URL query string (without the leading '?').
  static String objectToQueryString(Map<String, String> params) {
    return params.entries
        .where((e) => e.value.isNotEmpty)
        .map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
  }

  /// Appends [params] as a query string to [url], returning the combined URL.
  static String urlWithQueryString(String url, Map<String, String> params) {
    final query = objectToQueryString(params);
    if (query.isEmpty) return url;
    return '$url?$query';
  }
}
