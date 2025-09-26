import 'package:online_payments_sdk/src/native/api/native_method_channel.dart';
import 'package:online_payments_sdk/src/native/api/native_sdk_interface.dart';

NativeSdkInterface createPlatformSdkBridge() => NativeApiMethodChannel();
