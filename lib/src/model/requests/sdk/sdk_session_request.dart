/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2023 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */

import 'package:json_annotation/json_annotation.dart';

import '../../../constants.dart';

part 'sdk_session_request.g.dart';

/// Request used to initiate a [Session].
@JsonSerializable(explicitToJson: true)
class SdkSessionRequest {
  @JsonKey(required: true)
  final String clientSessionId;
  @JsonKey(required: true)
  final String customerId;
  @JsonKey(required: true)
  final String clientApiUrl;
  @JsonKey(required: true)
  final String assetUrl;
  @JsonKey(required: false, defaultValue: false)
  final bool isEnvironmentProduction;
  @JsonKey(
    required: true,
    defaultValue: "${Constants.appIdentifierPrefix}/UnknownAppId",
  )
  final String appIdentifier;
  @JsonKey(required: true, defaultValue: false)
  final bool loggingEnabled;
  @JsonKey(includeToJson: true, name: "sdkIdentifier")
  final String _sdkIdentifier = "FlutterClientSDK/v1.2.1";

  SdkSessionRequest(
    this.clientSessionId,
    this.customerId,
    this.clientApiUrl,
    this.assetUrl,
    this.isEnvironmentProduction,
    this.appIdentifier,
    this.loggingEnabled,
  );

  factory SdkSessionRequest.fromJson(Map<String, dynamic> json) =>
      _$SdkSessionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SdkSessionRequestToJson(this);
}
