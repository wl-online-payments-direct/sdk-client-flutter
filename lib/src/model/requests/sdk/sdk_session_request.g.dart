// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sdk_session_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SdkSessionRequest _$SdkSessionRequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'clientSessionId',
      'customerId',
      'clientApiUrl',
      'assetUrl',
      'appIdentifier',
      'loggingEnabled'
    ],
  );
  return SdkSessionRequest(
    json['clientSessionId'] as String,
    json['customerId'] as String,
    json['clientApiUrl'] as String,
    json['assetUrl'] as String,
    json['isEnvironmentProduction'] as bool? ?? false,
    json['appIdentifier'] as String? ?? 'flutter//UnknownAppId',
    json['loggingEnabled'] as bool? ?? false,
  );
}

Map<String, dynamic> _$SdkSessionRequestToJson(SdkSessionRequest instance) =>
    <String, dynamic>{
      'clientSessionId': instance.clientSessionId,
      'customerId': instance.customerId,
      'clientApiUrl': instance.clientApiUrl,
      'assetUrl': instance.assetUrl,
      'isEnvironmentProduction': instance.isEnvironmentProduction,
      'appIdentifier': instance.appIdentifier,
      'loggingEnabled': instance.loggingEnabled,
      'sdkIdentifier': instance._sdkIdentifier,
    };
