@JS()
library;

import 'dart:js_interop';

@JS('onlinepaymentssdk.MaskingUtil')
@staticInterop
class JsMaskingUtil {
  external factory JsMaskingUtil();
}

@JS('onlinepaymentssdk.MaskedString')
@staticInterop
class JsMaskedString {}

extension JsMaskedStringDetails on JsMaskedString {
  external String get formattedValue;

  external int get cursorIndex;
}

extension JsMaskingUtilMethods on JsMaskingUtil {
  external JsMaskedString applyMask(String? mask, String newValue, [String? oldValue]);

  external String removeMask(String? mask, String? value);
}
