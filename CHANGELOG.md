## 1.1.0
## Added
- Return an error result when attempting to make a Surcharge API call without required arguments.
- `Session` now supports the functionality to retrieve a Currency Conversion Quote. 

## Changed
- `PaymentProductFieldMasker`, `PaymentProductRequestMasker`, `AccountOnFileMasker`, `AccountOnFileCustomMaskedValueRequest`, `AccountOnFileMaskedValueRequest`, `PaymentProductFieldMaskRequest`, `PaymentRequestAllMaskedValuesRequest` and `PaymentRequestMaskedValueRequest`  have been made internal to the SDK. Use the masking functions on `AccountOnFile`, `PaymentProductField` and `PaymentRequest` instead.
- `PaymentRequestValidator`, `PaymentProductFieldValidator`, `ValidationRuleValidator`, `PaymentProductFieldValidationRequest`, `PaymentRequestRuleValidationRequest`, `PaymentRequestValidationRequest` and `ValidationRuleValidationRequest` have been made internal to the SDK. Use the validation functions on `PaymentProductField`, `PaymentRequest` and `ValidationRule` instead.
- Improved error handling when `Validator` cannot be decoded by the iOS bridge.
- Dependencies have been updated.

## Fixed
- Fixed an issue where an error occurred when using the SDK in combination with a `JAVA_HOME` version below 17 or an Android Studio Java version of below 17.

## Deprecated
- `stackTrace` in `NativeException` has been deprecated. Use `throwable` instead.
- `link` in `PaymentProductFieldDisplayHints` has been deprecated, since this property is never returned from the API.
- `PaymentProductFieldDisplayHints(bool, bool, int, String?, String, String?, String?, PreferredInputType?, Tooltip?, FormElement?)` constructor has been deprecated. This object should not be initialised, it is initialised automatically when returned from the API.

## 1.0.1
Fixed:
- Fixed an issue for iOS where using an Account on File without modifying values returned validation errors.
## 1.0.0
 Initial release of the Flutter SDK that can be used to connect to the Worldline Online Payment Services Client API. The SDK can only be used on the Android and iOS platforms.
 
