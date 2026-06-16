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

import '../domain/configuration/session_data.dart';
import '../domain/errors/configuration_error.dart';

/// Validates and sanitizes [SessionData] before passing it to the SDK.
/// Throws [ConfigurationError] if any required field is missing or [clientApiUrl] is invalid.
SessionData normalizeSessionData(SessionData sessionData) {
  _validateRequiredFields(sessionData);
  final sanitizedUrl = _sanitizeClientApiUrl(sessionData.clientApiUrl);

  return SessionData(
    clientSessionId: sessionData.clientSessionId,
    customerId: sessionData.customerId,
    clientApiUrl: sanitizedUrl,
    assetUrl: sessionData.assetUrl,
  );
}

void _validateRequiredFields(SessionData data) {
  final fields = <String, String>{
    'clientSessionId': data.clientSessionId,
    'customerId': data.customerId,
    'clientApiUrl': data.clientApiUrl,
    'assetUrl': data.assetUrl,
  };

  for (final entry in fields.entries) {
    if (entry.value.isEmpty) {
      throw ConfigurationError("The SessionData parameter '${entry.key}' is mandatory.");
    }
  }
}

String _sanitizeClientApiUrl(String inputUrl) {
  final Uri uri;
  try {
    uri = Uri.parse(inputUrl);
    if (!uri.hasScheme || uri.host.isEmpty) {
      throw ConfigurationError(
        "A valid URL is required for the 'clientApiUrl', you provided '$inputUrl'",
      );
    }
  } catch (e) {
    if (e is ConfigurationError) rethrow;
    throw ConfigurationError(
      "A valid URL is required for the 'clientApiUrl', you provided '$inputUrl'",
    );
  }

  final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();

  if (segments.isEmpty) {
    return uri.replace(path: '/client').toString();
  }

  if (segments.length > 1 || segments[0] != 'client') {
    throw ConfigurationError(
      "The path is unexpected, you supplied: '${uri.path}'. It should be empty or '/client'.",
    );
  }

  return uri.replace(path: '/client').toString();
}

