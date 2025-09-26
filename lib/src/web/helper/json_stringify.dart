@JS()
library;

import 'dart:js_interop';

@JS('JSON.stringify')
external String jsStringify(JSAny value);
