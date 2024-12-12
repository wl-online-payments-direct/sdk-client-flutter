## 1.2.2
## Changed:
- Updated the Swift dependency. This fixes the compatibility issue with the latest Xcode.


## 1.2.1
## Changed:
- Updated the `README`.
- Updated the Swift dependency.


## 1.2.0
### Added: 
- Added a simple example application that showcases how you can implement a Payment Product call using the SDK 
- Added a `label` property to `AccountOnFile`. Use this property to obtain a masked version of the obfuscated card number. This value should be shown to your customer when they are selecting previously used payment methods. 
- Added the following properties to `ApiErrorItem`: `errorCode`, `category`, `httpStatusCode`, `id`, `propertyName` and `retriable`. You can use these properties to get more information about Api errors. 

### Changed: 
- Updated dependencies 
- Java 17 is now used to build the Android bridge 
- The `AccountOnFile`’s `label` property now returns its masked value or an empty `String` if no mask if found, Previous it could possible return an appended `String` 

### Deprecated: 
- Deprecated the `imageUrl` property on `Tooltip` since it is never returned from the API 
- Deprecated the `code` property on `ApiErrorItem`, use `errorCode` instead 


## 1.1.2
### Changed 
- Updated dependencies.

### Fixed
- Fixed an issue where a `ValidationErrorMessage` with an `ValidationRule` would miss additional `ValidationRule` properties such as `minLength` and `maxLength` for `ValidationRuleLength`.


## 1.1.1
### Fixed
- Fixed an issue where the iOS implementation of the Flutter SDK could not build due to missing transitive dependencies. These are now declared in the podspec so they will be downloaded upon `pod install`.
- Fixed an issue where the metadata in the network calls did not indicate the Flutter SDK correctly. 


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
 
