import 'package:online_payments_sdk/src/native/api/native_sdk_interface.dart';
import 'package:online_payments_sdk/src/web/adapter/web_session_adapter.dart';
import 'package:online_payments_sdk/src/web/api/web_api_bridge.dart';

NativeSdkInterface createPlatformSdkBridge() => WebSessionAdapter(WebApiBridge());
