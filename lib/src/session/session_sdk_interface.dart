import 'package:online_payments_sdk/src/native/api/native_sdk_interface.dart';

import 'session_sdk_interface_stub.dart'
    if (dart.library.html) 'session_sdk_interface_web.dart'
    if (dart.library.io) 'session_sdk_interface_native.dart';

export 'package:online_payments_sdk/src/native/api/native_sdk_interface.dart';

final NativeSdkInterface platformSdkBridge = createPlatformSdkBridge();
