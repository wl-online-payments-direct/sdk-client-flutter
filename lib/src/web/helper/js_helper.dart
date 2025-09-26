import 'dart:js_interop';

import 'package:js/js_util.dart';

extension JSObjectUtils on JSObject {
  bool hasJson() => hasProperty(this, 'json'.toJS);

  JSAny getJsonOrSelf() {
    return hasJson() ? getProperty(this, 'json'.toJS) as JSAny : this;
  }
}
