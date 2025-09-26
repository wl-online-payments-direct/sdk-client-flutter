# 4.2.2

## Changed

* Rebuilt the project with the Xcode 26.0.1 (17A400) and Swift 6.2.
* The library is now built with the `BUILD_FOR_DISTRIBUTION` flag.

# 4.2.1

## Changed

* Renamed internal properties of Validators for compatibility reasons. Since this is an internal class, it should not
  affect any consumer.
* The expiration date validator now accepts values in MMyy and MMyyyy formats, but the validation still depends on the 
  specific payment product `expiryDate` field validation rules returned from the API.

# 4.2.0

## Changed

Filtering of payment products that cannot be sent in the encrypted customer input has been added to C2sCommunicator. The
following methods are currently unsupported:

* Maestro (117)
* Intersolve (5700)
* Sodexo & Sport Culture (5772)
* VVV Giftcard (5784)

## Deprecated

* `PaymentContext.locale` has been marked deprecated and should not be used anymore, since it does not influence
  behavior.

# 4.1.1

## Changed

* The `PaymentRequest` object now accepts both masked and unmasked values.

# 4.1.0

## Changed

* Set encryption to r`saEncryptionOAEPSHA1`.
* Improve readability of `C2SCommunicator`.
* Fix Alamofire wrapper by removing deprecated calls.

# 4.0.1

## Changed

* The `AccountOnFile` id property in the Payment Request JSON is now stored as string.

# 4.0.0

## Changed

The minimal supported iOS version of the SDK is now 15.6.

Members access modifiers are changed for the following:

* `Session.clientSessionId` has been made internal.
* `decimalRegex`, `lowerAlphaRegex`, `upperAlphaRegex` has been made internal of the class `StringFormatter`.
* `numberFormatter` and `numericStringCheck` has been made private of the class `PaymentProductField`.

Payment products do not have `displayHints` and `displayHintsList` anymore. `displayHintsList` has been removed and
`displayHints` is now `List`. Affected classes: `PaymentProductGroup`, `BasicPaymentProduct`,
`BasicPaymentProductGroup`, `BasicPaymentItem`.

In the `Session` class, parameter `groupPaymentProducts` has been removed from the `paymentItems` method (
`@objc paymentItemsForContext`) since it was not being used.

Encryption methods now throw `EncryptionError` when something is not correct.

All tests have been updated to reflect the changes.

## Deleted

The following deprecated members have been removed:

* `ApiErrorItem.code`; use `errorCode` instead.
* `AccountOnFileAttribute.mustWriteReason`; no replacement needed.
* `PreferredInputType.noKeyboard`; no replacement needed.
* `AmountOfMoney.currencyCodeString`; use `currencyCode` instead.
* `PaymentContext.countryCodeString`; use `countryCode` instead.
* `IINDetailsResponse.countryCodeString`; use `countryCode` instead.
* `FormElement.valueMapping`; no replacement needed.
* `PaymentProductField.usedForLookup`; no replacement needed.
* `PaymentProductField.errors`; use `errorMessageIds` instead.
* `PaymentProductField.validateValue(value: String, for request: PaymentRequest)`; use `validateValue(value:)` or
  `validateValue(for:)`.
* `PaymentProductFieldDisplayHints.link`; no replacement needed.
* `ToolTip.imagePath` and `ToolTip.image` ; no replacement needed.
* `PaymentRequest.errors`; use `errorMessageIds` instead.
* method `validate(value:, for request:)` from **all** validators; use `validate(field:in:)` instead.
* `SDKConstants.kSDKLocalizable`; no replacement needed since no localization is provided.

The following classes have been removed:

* `DisplayElement`
* `ValueMappingItem`

The `init?(json: [String: Any])` method has been removed from the following classes:

* `AccountOnFile`
* `AccountOnFileAttribute`
* `AmountOfMoney`
* `IINDetail`
* `IINDetailsResponse`
* `BasicPaymentProduct`
* `BasicPaymentProducts`
* `BasicPaymentProductGroup`
* `BasicPaymentProductGroups`
* `DataRestrictions`
* `FormElement`
* `LabelTemplateItem`
* `PaymentProduct`
* `PaymentProductField`
* `PaymentProductFieldDisplayHints`
* `PaymentProductGroup`
* `ToolTip`
* `Surcharge`
* `SurchargeCalculationResponse`
* `ValidatorFixedList`
* `ValidatorLength`
* `ValidatorRange`
* `ValidatorRegularExpression`

Several (Objective-C) deprecated methods from the `Session` class have been removed:

* `paymentProductNetworks(forProductId:context:success:failure:)`; use
  `paymentProductNetworks(forProductId:context:success:failure:apiFailure:)` instead.
* `paymentProducts(context:success:failure)`; use `paymentProductsForContext(context:success:failure:apiFailure:)`
  instead.
* `paymentItemsForContext(groupPaymentProducts:success:failure:)`; use
  `paymentItemsForContext(groupPaymentProducts:success:failure:apiFailure:)` instead.
* `paymentProductWithId(context:success:failure:)`; use `paymentProductWithId(context:success:failure:apiFailure:)`
  instead.
* `IINDetailsForPartialCreditCardNumber(context:success:failure:)`; use
  `IINDetailsForPartialCreditCardNumber(context:success:failure:apiFailure:)` instead.
* `publicKeyWithSuccess(failure:)`; use `publicKeyWithSuccess(:failure:apiFailure:)`
* `preparePaymentRequest(success:failure:)`; use `preparePaymentRequest(success:failure:apiFailure:)` instead.
* `surchargeCalculation(amountOfMoney:partialCreditCardNumber:paymentProductId:success:failure:)`; use
  `surchargeCalculation(amountOfMoney:partialCreditCardNumber:paymentProductId:success:failure:apiFailure:)` instead.
* `surchargeCalculation(amountOfMoney:token:success:failure:)`; use
  `surchargeCalculation(amountOfMoney:token:success:failure:apiFailure:)` instead.
