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

import 'package:http/http.dart' as http;

/// A test double for [http.BaseClient] that captures outgoing requests and
/// allows configuring fixed responses, network errors, and invalid JSON responses.
class TestHttpClient extends http.BaseClient {
  final List<http.BaseRequest> capturedRequests = [];
  late int _status;
  late String _body;
  bool _shouldThrow = false;

  void setResponse(int status, Map<String, dynamic> body) {
    _status = status;
    _body = jsonEncode(body);
    _shouldThrow = false;
  }

  void setInvalidJsonResponse() {
    _status = 200;
    _body = 'not json {{{';
    _shouldThrow = false;
  }

  void setNetworkError() {
    _shouldThrow = true;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    capturedRequests.add(request);

    if (_shouldThrow) throw Exception('Network error');

    return http.StreamedResponse(
      Stream.value(utf8.encode(_body)),
      _status,
      headers: const {'content-type': 'application/json'},
    );
  }
}
