# 3.0.1

- Additionally expanded integration test coverage across all major SDK components.

# 3.0.0

The Flutter SDK was rewritten as a pure-Dart implementation, replacing the previous
Android/iOS native bridge architecture. This release is a full breaking change.
For usage examples, see `README.md`.

## Changed

- The main entry point changed from `Session` to `OnlinePaymentSdk`. It is now instantiated
  directly with `OnlinePaymentSdk(sessionData, configuration?)`.
- All SDK methods are now `async`/`await`-based `Future`s instead of callback listeners.
- Fluent API added for domain models:
  - `PaymentProductField`:
    - `validate(value)` returns a `List<ValidationErrorMessage>` (replaces `validateValue()`).
    - `applyMask(value)` and `removeMask(value)` are now synchronous.
    - Added: `getLabel()`, `getPlaceholder()`, `getDisplayOrder()`, `isRequired()`, `shouldObfuscate()`.
  - `PaymentRequest`:
    - Constructor now requires `PaymentProduct`.
    - `validate()` returns a `ValidationResult` containing validation errors (synchronous).
    - Field values are managed through `PaymentRequestField` instances.
    - Setting `AccountOnFile` automatically clears non-writable field values set previously
      on the payment request.
    - Setting a value to a `READ_ONLY` field throws `InvalidArgumentError`.
- The `EncryptedRequest` property `encryptedFields` was renamed to `encryptedCustomerInput` to
  match the field expected by the Create Payment request.
- `paymentProduct.id` is now `int?` (previously `String`).

## Added

- `PaymentProduct`: added methods for field access:
  - `getFields()` — returns all fields.
  - `getRequiredFields()` — returns only required fields.
  - `getField(id)` — returns a specific field by ID.
- `PaymentRequestField`: class for field value management with methods:
  - `getValue()`, `setValue(value)`, `clearValue()`.
  - `getMaskedValue()`, `getType()`.
  - `getId()`, `getLabel()`, `getPlaceholder()`, `isRequired()`, `shouldObfuscate()`.
  - `validate()` — validates an individual field value.
- `PaymentRequest`: added methods:
  - `getField(id)` — returns `PaymentRequestField` for fluent API.
  - `getValues()` — returns all unmasked values as a map.
  - `validate()` — validates the entire request and returns `ValidationResult`.
- `AccountOnFile`: added methods:
  - `getValue(fieldId)` — gets stored value for a field.
  - `getRequiredAttributes()` — gets attributes that must be provided.
  - `isWritable(fieldId)` — checks whether a field can be modified.
- `BasicPaymentProduct`: added method:
  - `getAccountOnFile(id)` — retrieves a specific account on file.
- `ValidationResult`: class wrapping validation results with:
  - `isValid` — boolean indicating whether validation passed.
  - `errors` — list of `ValidationErrorMessage`.
- Error hierarchy:
  - `SdkError` — abstract base class for all SDK errors.
  - `ConfigurationError` — invalid session or configuration data.
  - `InvalidArgumentError` — invalid method arguments.
  - `CommunicationError` — network or connection failure.
  - `ResponseError` — API request failures (includes HTTP status).
  - `ApiError` — structured API error response.
  - `EncryptionError` — encryption or validation failures.
- `SdkConfiguration` parameter with `appIdentifier` property to identify the integrating
  application.
- `getPublicKey()` method on `OnlinePaymentSdk` to retrieve the server's public encryption key.
- `CreditCardTokenRequest` and `encryptTokenRequest()` for encrypting token-only requests.
- Significantly expanded unit and integration test coverage across all major SDK components.

## Removed

- `Session` class removed. Use `OnlinePaymentSdk` directly.
- `NativeException` and `ErrorResponse` removed. SDK now throws `SdkError` subclasses.
- `BasicPaymentItems` class and `getBasicPaymentItems()` removed. Use `getBasicPaymentProducts()`.
- Callback listener pattern (`SuccessListener`, `ErrorListener`, etc.) removed entirely.
- Native bridge implementation removed:
  - `android/` folder and all Android bridge modules.
  - `ios/` folder and all iOS bridge modules and framework wrappers.
  - `web/` folder and the JavaScript SDK dependency removed.
  - The SDK is now a pure-Dart package with no native dependencies.

# 2.1.0

# Changed:

* Updated `freezed` dependency with the related dependencies to the latest version
* Updated the SDK API annotations

# 2.0.0

## API Changes

The following changes are affecting the consumers of the SDK.

### Added:

* Our SDK now has the web support. This means you can use it in web projects.

### Changed:

* Updated native SDK dependencies: now using the latest version of Android (v4.1.1), Swift (v4.2.2),
  and JS (v3.4.0) SDKs. 
* The Swift package is built with the latest Swift build for Xcode 26 and Swift 6.2 and now supports
  library distribution.
* Some payment products are not supported in the encrypted payment request, so they are now filtered
  out from the list of available payment products. These products are filtered:
  * Maestro (id: 117)
  * Intersolve (id: 5700)
  * Sodexo & Sport Culture (id: 5772)
  * VVV Giftcard (id: 5784)

* **Breaking change:** When validating a single payment product field, you now need to provide the
  second parameter to the `validateValue` method which is the `PaymentProduct` instance,
  for example, `final validationErrorMessages = await field.validateValue(value, paymentProduct);`. 
  This does not affect validating a payment request. This change will be reverted in next major 
  release.

### Removed

Removed deprecated properties: 

* `code` from `ApiErrorItem`,
* `stackTrace` from `NativeException`, 
* `link` from `PaymentProductFieldDisplayHints`, and
* `imageUrl` from `Tooltip`.

## Internal changes

The following changes were done to the project code and structure, but they are not affecting how
the SDK is used.

## Added

* Improved tests and test coverage
* Introduced the handler classes as part of the SDK bridge refactor to encapsulate the
  domain-specific logic.

## Changed:

* Refactored the monolithic `SdkBridge` into modular, domain-specific handler classes to improve
  maintainability and code separation.
* Changed the project folder structure by domain (e.g. `model/`, `native/`, `listeners/`) for
  improved clarity.
* Renamed all files to follow the Dart `snake_case` naming convention.
* Moved misplaced files (e.g. `session.dart`, masking logic, validators) to appropriate locations
  within the project.
* Removed the `Context` parameter from the individual `Session` method calls, now passed via the
  `Session` constructor.
* Updated the `MethodChannel` implementation to support new Android SDK interface.
* Renamed the `ValidationType` to `Type` enum for the validation rule deserialization compatibility.
* Renamed the `validationType` field to `type` in the `payment_product_response.json` test fixture
  for the compatibility reasons.
* Replaced property access (e.g. `.unmaskedValue()`) with explicit method calls (e.g.
  `getUnmaskedValue()`) due to removal of public properties.
* Removed serialization of the validationRules in the data restrictions in favor of keeping the 
  native validators map.

# 1.3.4

## Changed:
- 
- iOS package dependency has been rebuilt with Xcode 16.4.

# 1.3.3

## Changed:

- Updated the Swift dependency to support setting masked values to the PaymentRequest.

# 1.3.2

## Changed:

- Updated the Swift dependency to support iOS encryption update.

# 1.3.1

## Added:

- Added consumerProguardFiles 'proguard-rules.pro' to the library’s Gradle config, ensuring classes
  are
  preserved when minification is enabled.

# 1.3.0

## Changed:

- Changed the `AccountOnFile.id` property to type `string`.

# 1.2.3

## Changed:

- Updated the Swift dependency to support iOS 18.2.

# 1.2.2

## Changed:

- Updated the Swift dependency. This fixes the compatibility issue with the latest Xcode.

# 1.2.1

## Changed:

- Updated the `README`.
- Updated the Swift dependency.

# 1.2.0

## Added:

- Added a simple example application that showcases how you can implement a Payment Product call
  using the SDK
- Added a `label` property to `AccountOnFile`. Use this property to obtain a masked version of the
  obfuscated card number. This value should be shown to your customer when they are selecting
  previously used payment methods.
- Added the following properties to `ApiErrorItem`: `errorCode`, `category`, `httpStatusCode`, `id`,
  `propertyName` and `retriable`. You can use these properties to get more information about Api
  errors.

## Changed:

- Updated dependencies
- Java 17 is now used to build the Android bridge
- The `AccountOnFile`’s `label` property now returns its masked value or an empty `String` if no
  mask if found, Previous it could possible return an appended `String`

## Deprecated:

- Deprecated the `imageUrl` property on `Tooltip` since it is never returned from the API
- Deprecated the `code` property on `ApiErrorItem`, use `errorCode` instead

# 1.1.2

## Changed

- Updated dependencies.

## Fixed

- Fixed an issue where a `ValidationErrorMessage` with an `ValidationRule` would miss additional
  `ValidationRule` properties such as `minLength` and `maxLength` for `ValidationRuleLength`.

# 1.1.1

## Fixed

- Fixed an issue where the iOS implementation of the Flutter SDK could not build due to missing
  transitive dependencies. These are now declared in the podspec so they will be downloaded upon
  `pod install`.
- Fixed an issue where the metadata in the network calls did not indicate the Flutter SDK correctly.

# 1.1.0

## Added

- Return an error result when attempting to make a Surcharge API call without required arguments.
- `Session` now supports the functionality to retrieve a Currency Conversion Quote.

## Changed

- `PaymentProductFieldMasker`, `PaymentProductRequestMasker`, `AccountOnFileMasker`,
  `AccountOnFileCustomMaskedValueRequest`, `AccountOnFileMaskedValueRequest`,
  `PaymentProductFieldMaskRequest`, `PaymentRequestAllMaskedValuesRequest` and
  `PaymentRequestMaskedValueRequest`  have been made internal to the SDK. Use the masking functions
  on `AccountOnFile`, `PaymentProductField` and `PaymentRequest` instead.
- `PaymentRequestValidator`, `PaymentProductFieldValidator`, `ValidationRuleValidator`,
  `PaymentProductFieldValidationRequest`, `PaymentRequestRuleValidationRequest`,
  `PaymentRequestValidationRequest` and `ValidationRuleValidationRequest` have been made internal to
  the SDK. Use the validation functions on `PaymentProductField`, `PaymentRequest` and
  `ValidationRule` instead.
- Improved error handling when `Validator` cannot be decoded by the iOS bridge.
- Dependencies have been updated.

## Fixed

- Fixed an issue where an error occurred when using the SDK in combination with a `JAVA_HOME`
  version below 17 or an Android Studio Java version of below 17.

## Deprecated

- `stackTrace` in `NativeException` has been deprecated. Use `throwable` instead.
- `link` in `PaymentProductFieldDisplayHints` has been deprecated, since this property is never
  returned from the API.
-

`PaymentProductFieldDisplayHints(bool, bool, int, String?, String, String?, String?, PreferredInputType?, Tooltip?, FormElement?)`
constructor has been deprecated. This object should not be initialised, it is initialised
automatically when returned from the API.

# 1.0.1

## Fixed

- Fixed an issue for iOS where using an Account on File without modifying values returned validation
  errors.

# 1.0.0

Initial release of the Flutter SDK that can be used to connect to the Worldline Online Payment
Services Client API. The SDK can only be used on the Android and iOS platforms.
 
