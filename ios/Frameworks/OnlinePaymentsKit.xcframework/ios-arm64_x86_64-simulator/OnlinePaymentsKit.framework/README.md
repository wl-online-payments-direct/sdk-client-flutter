# Online Payments Swift SDK

The Online Payments Swift SDK helps you with accepting payments in your iOS app, supporting iOS 15.6 and up, through the Online Payments platform.

The SDK's main function is to establish a secure channel between your iOS app and our server. This channel processes security credentials to guarantee the safe transit of your customers' data during the payment process.

**The Online Payments SDK helps you with:**
- Handling encryption of the payment context
- Convenient Swift wrappers for API responses
- User-friendly formatting of payment data, such as card numbers and expiry dates
- Validating user input
- Determining the card's associated payment provider

## Table of Contents

- [Online Payments Swift SDK](#online-payments-swift-sdk)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
    - [CocoaPods](#cocoapods)
    - [Carthage](#carthage)
    - [Swift Package Manager](#swift-package-manager)
  - [Objective-C Compatibility](#objective-c-compatibility)
  - [Example app](#example-app)
  - [Getting started](#getting-started)
  - [Type definitions](#type-definitions)
    - [Session](#session)
      - [Logging of requests and responses](#logging-of-requests-and-responses)
    - [PaymentContext](#paymentcontext)
    - [PaymentItems](#paymentitems)
    - [BasicPaymentProduct](#basicpaymentproduct)
    - [AccountOnFile](#accountonfile)
    - [PaymentProduct](#paymentproduct)
    - [PaymentProductField](#paymentproductfield)
    - [PaymentRequest](#paymentrequest)
      - [Tokenize payment request](#tokenize-payment-request)
      - [Set field values to payment request](#set-field-values-to-payment-request)
      - [Validate payment request](#validate-payment-request)
      - [Encrypt payment request](#encrypt-payment-request)
    - [IINDetails](#iindetails)
    - [StringFormatter](#stringformatter)
  - [Payment Steps](#payment-steps)
    - [1. Initialize the Swift SDK for this payment](#1-initialize-the-swift-sdk-for-this-payment)
    - [2. Retrieve the payment items](#2-retrieve-the-payment-items)
    - [3. Retrieve payment product details](#3-retrieve-payment-product-details)
    - [4. Encrypt payment information](#4-encrypt-payment-information)
    - [5. Response from the Server API call](#5-response-from-the-server-api-call)

## Installation

The Online Payments Swift SDK is available via the following package managers: [CocoaPods](https://cocoapods.org/), [Carthage](https://github.com/Carthage/Carthage) or [Swift Package Manager](https://github.com/apple/swift-package-manager).

### CocoaPods

You can add the Swift SDK as a pod to your project by adding the following to your `Podfile`:

```
$ pod 'OnlinePaymentsKit'
```

Afterwards, run the following command:

```
$ pod install
```

### Carthage

You can add the Swift SDK with Carthage, by adding the following to your `Cartfile`:

```
$ github "online-payments/sdk-client-swift"
```

Afterwards, run the following command:

```
$ carthage update --use-xcframeworks
```

Navigate to the ```Carthage/Build``` directory, which was created in the same directory as where the ```.xcodeproj``` or ```.xcworkspace``` is. Inside this directory the ```.xcframework``` bundle is stored. Drag the ```.xcframework``` into the "Framework, Libraries and Embedded Content" section of the desired target. Make sure that it is set to "Embed & Sign". 

### Swift Package Manager

You can add the Swift SDK with Swift Package Manager, by configuring your project as following:

1. Go to your project's settings and click the 'Package Dependencies' tab.
2. Click the '+' to add a new Swift Package dependency.
3. Enter the Github URL in the search bar: `https://github.com/online-payments/sdk-client-swift`
4. Additionally, you can also set a version of the package that you wish to include. The default option is to select the latest version from the main branch.
5. Click 'Add package'

When the package has successfully been added, it will automatically be added as a dependency to your targets as well.

## Objective-C Compatibility

The Online Payments Swift SDK can also be used in Objective-C projects by using CocoaPods or Carthage. Once you have added Online Payments Kit as a dependency, it can easily be used by adding the following import statement where you want to use the SDK:
`@import OnlinePaymentsKit;` 

## Example apps

For your convenience, we also provide an example application in both SwiftUI and UIKit that can be used as a basis for your own implementation. If you are fine with the look-and-feel of the example app, you do not need to make any changes at all. Take a look at the [SwiftUI](https://github.com/online-payments/sdk-client-swift-example-swiftui) or [UIKit](https://github.com/online-payments/sdk-client-swift-example) example apps.`

## Getting started

To accept your first payment using the SDK, complete the steps below. Also see the section [Payment Steps](#payment-steps) for more details on these steps.

1. Request your server to create a Client Session, using one of our available Server SDKs. Return the session details to your app.
2. Initialize the SDK using the session details.
```swift
let session = Session(
    clientSessionId: "47e9dc332ca24273818be2a46072e006",
    customerId: "9991-0d93d6a0e18443bd871c89ec6d38a873",
    baseURL: "https://clientapi.com",
    assetBaseURL: "https://assets.com",
    appIdentifier: "Swift Example Application/v2.0.4",
    loggingEnabled: true // set this to false in production
)
```
3. Configure your payment context.
```swift
let amountOfMoney = AmountOfMoney(
    totalAmount: 1298, // in cents
    currencyCode: "EUR" // three letter currency code as defined in ISO 4217
)

let paymentContext = PaymentContext(
    amountOfMoney: amountOfMoney,
    isRecurring: false, // true, if it is a recurring payment
    countryCode: "NL" // two letter country code as defined in ISO 3166-1 alpha-2
)
```
4. Retrieve the available Payment Products. Display the `BasicPaymentItem` and `AccountOnFile` lists and request your customer to select one.
```swift
session.paymentItems(
    for: paymentContext,
    success: { paymentItems in
        // Display the contents of paymentItems & accountsOnFile to your customer
    },
    failure: { error in
        // Inform the customer that something went wrong while retrieving the available Payment Products
    },
    apiFailure: { errorResponse in
        // Inform the customer that the API threw an error while retrieving the available Payment Products
    }
)
```
5. Once the customer has selected the desired payment product, retrieve the enriched `PaymentProduct` detailing what information the customer needs to provide to authorize the payment. Display the required information fields to your customer.
```swift
session.paymentProduct(
    withId: "1", // replace with the id of the payment product that should be fetched
    context: paymentContext,
    success: { paymentProduct in
        // Display the fields to your customer
    },
    failure: { error in
        // Handle failure of retrieving a Payment Product by id
    },
    apiFailure: { errorResponse in
        // Handle API failure of retrieving a Payment Product by id
    }
)
```
6. Save the customer's input for the required information fields in a `PaymentRequest`. These should be unmasked values.
```swift
let paymentRequest = PaymentRequest()

paymentRequest.setValue(forField: "cardNumber", value: "12451254457545")
paymentRequest.setValue(forField: "cvv", value: "123")
paymentRequest.setValue(forField: "expiryDate", value: "1225")
```
7. Validate and encrypt the payment request. The encrypted customer data should then be sent to your server.
```swift
session.prepare(
    paymentRequest,
    success: { preparedPaymentRequest in
        // Forward the encryptedFields to your server
    },
    failure: { error in
        // Handle failure of encrypting Payment Request
    },
    apiFailure: { errorResponse in
        // Handle API failure of encrypting Payment Request
    }
)
```
8. Request your server to create a payment request, using the Server API's Create Payment call. Provide the encrypted data in the `encryptedCustomerInput` field.

## Type definitions
### Session

For all interactions with the SDK an instance of `Session` is required. The following code fragment shows how `Session` is initialized. The session details are obtained by performing a Create Client Session call using the Server API.
```swift
let session = Session(
    clientSessionId: "47e9dc332ca24273818be2a46072e006",
    customerId: "9991-0d93d6a0e18443bd871c89ec6d38a873",
    baseURL: "https://clientapi.com",
    assetBaseURL: "https://assets.com",
    appIdentifier: "Swift Example Application/v2.0.4",
    loggingEnabled: true // set this to false in production
)
```
Almost all methods that are offered by `Session` are simple wrappers around the Client API. They create the request and convert the response to Swift objects that may contain convenience functions.

#### Logging of requests and responses
You are able to log requests made to the server and responses received from the server. By default logging is disabled, and it is important to always disable it in production. You are able to enable the logging in two ways. Either by setting its value when creating a Session - as shown in the code fragment above - or by setting its value after the Session was already created.
```swift
session.loggingEnabled = true
```

### PaymentContext

`PaymentContext` is an object that contains the context/settings of the upcoming payment. It is required as an argument to some of the methods of the `Session` instance. This object can contain the following details:
```swift
public class PaymentContext {
    var countryCode: String // ISO 3166-1 alpha-2 country code
    var locale: String // IETF Language Tag + ISO 15897, example: 'nl_NL'
    var amountOfMoney: AmountOfMoney // contains the total amount and the ISO 4217 currency code
    var isRecurring: Bool // Set `true` when payment is recurring. Default false.
}
```

### PaymentItems
This object contains the available Payment Items for the current payment. Use the `session.paymentItems` function to request the data.

The object you will receive is `PaymentItems`, which contains three lists. One for all available `BasicPaymentItem`s, one for all grouped `BasicPaymentItem`s and one that contains all `AccountOnFile`s.

The code fragment below shows how to get the `PaymentItems` instance.
```swift
session.paymentItems(
    for: paymentContext,
    success: { paymentItems in
        // Display the contents of paymentItems & accountsOnFile to your customer
    },
    failure: { error in
        // Inform the customer that something went wrong while retrieving the available Payment Products
    },
    apiFailure: { errorResponse in
        // Inform the customer that the API threw an error while retrieving the available Payment Products
    }
)
```

### BasicPaymentProduct

The SDK offers two types to represent information about payment products:
`BasicPaymentProduct` and `PaymentProduct`. Practically speaking, instances of `BasicPaymentProduct` contain only the information that is required to display a simple list of payment products from which the customer can select one.

The type `PaymentProduct` contains additional information, such as the specific form fields that the customer is required to fill out. This type is typically used when creating a form that asks the customer for their details. See the [PaymentProduct](#paymentproduct) section for more info.

Below is an example for how to obtain display names and assets for the Visa product (id: 1).
```swift
let basicPaymentProduct = paymentItems.paymentItem(withIdentifier: "1")

let id = basicPaymentProduct.identifier // 1
let label = basicPaymentProduct.displayHints.first?.label // VISA
let logoPath = basicPaymentProduct.displayHints.first?.logoPath // https://assets.com/path/to/visa/logo.gif
```

### AccountOnFile

An instance of `AccountOnFile` represents information about a stored card product for the current customer. `AccountOnFile` IDs available for the current payment must be provided in the request body of the Server API's Create Client Session call. If the customer wishes to use an existing `AccountOnFile` for a payment, the selected `AccountOnFile` should be added to the `PaymentRequest`. The code fragment below shows how display data for an account on file can be retrieved. This label can be shown to the customer, along with the logo of the corresponding payment product.
```swift
// All available accounts on file for the payment product
let allAccountsOnFile = basicPaymentProduct.accountsOnFile.accountsOnFile

// Get specific account on file for the payment product
let accountOnFile = basicPaymentProduct.accountOnFile(withIdentifier: "123")

// Shows a mask based formatted value for the obfuscated cardNumber.
// The mask that is used is defined in the displayHints of this accountOnFile
// If the mask for the "cardNumber" field is {{9999}} {{9999}} {{9999}} {{9999}}, then the result would be **** **** **** 7412
let maskedValue = accountOnFile.maskedValue(forField: "cardNumber")
```

### PaymentProduct

`BasicPaymentProduct` only contains the information required by a customer to distinguish one payment product from another. However, once a payment product or an account on file has been selected, the customer must provide additional information, such as a bank account number, a credit card number, or an expiry date, before a payment can be processed. Each payment product can have several fields that need to be completed to process a payment. Instances of `BasicPaymentProduct` do not contain any information about these fields.

Information about the fields of payment products are represented by instances of `PaymentProductField`, which are contained in instances of `PaymentProduct`. The class `PaymentProductField` is described further down below. The `Session` instance can be used to retrieve instances of `PaymentProduct`, as shown in the following code fragment.
```swift
session.paymentProduct(
    withId: "1", // replace with the id of the payment product that should be fetched
    context: paymentContext,
    success: { paymentProduct in
        // Display the fields to your customer
    },
    failure: { error in
        // Handle failure of retrieving a Payment Product by id
    },
    apiFailure: { errorResponse in
        // Handle API failure of retrieving a Payment Product by id
    }
)
```

### PaymentProductField

The fields of payment products are represented by instances of `PaymentProductField`. Each field has an identifier, a type, a definition of restrictions that apply to the value of the field, and information about how the field should be presented graphically to the customer. Additionally, an instance of a field can be used to determine whether a given value is valid for the field.

In the code fragment below, the field with identifier `"cvv"` is retrieved from a payment product. The data restrictions of the field are inspected to see whether the field is a required field or an optional field. Additionally, the display hints of the field are inspected to see whether the values a customer provides should be obfuscated in a user interface.
```swift
let cvvField = paymentProduct.paymentProductField(withId: "cvv")

let isRequired = cvvField.dataRestrictions.isRequired // state if value is required for this field
let shouldObfuscate = cvvField.displayHints.obfuscate // state if field value should be obfuscated
```

### PaymentRequest

Once a payment product has been selected and an instance of `PaymentProduct` has been retrieved, a payment request can be constructed. This class must be used as a container for all the values the customer provides.
```swift
let paymentRequest = PaymentRequest(paymentProduct: paymentProduct)
```

#### Tokenize payment request

A `PaymentProduct` has a property `tokenize`, which is used to indicate whether a payment request should be stored as an account on file. The code fragment below shows how a payment request should be constructed when the request should be stored as an account on file. By default, `tokenize` is set to `false`.
```swift
let paymentRequest = PaymentRequest(paymentProduct: paymentProduct) // when you do not pass the tokenize value, it will be false

// you can supply tokenize via the constructor
let paymentRequest = PaymentRequest(paymentProduct: paymentProduct, tokenize: true)

// or by accessing the request's tokenize property
paymentRequest.tokenize = true
```

If the customer selected an account on file, both the account on file and the corresponding payment product must be supplied while constructing the payment request, as shown in the code fragment below. Instances of `AccountOnFile` can be retrieved from instances of `BasicPaymentProduct` and `PaymentProduct`.
```swift
// you can supply accountOnFile via the constructor
let paymentRequest = PaymentRequest(
    paymentProduct: paymentProduct,
    accountOnFile: accountOnFile // when you do not pass the accountOnFile value, it will be nil
)

// or by accessing the request's accountOnFile property
paymentRequest.accountOnFile = accountOnFile
```

#### Set field values to payment request

Once a payment request has been configured, the value for the payment product's fields can be supplied as shown below. The identifiers of the fields, such as "cardNumber" and "cvv" in the example below, are used to set the values of the fields using the payment request.
```swift
paymentRequest.setValue(forField: "cardNumber", value: "1245 1254 4575 45")
paymentRequest.setValue(forField: "cvv", value: "123")
paymentRequest.setValue(forField: "expiryDate", value: "12/25")
```

#### Validate payment request

Once all values have been supplied, the payment request can be validated. Behind the scenes the validation uses the `DataRestrictions` class for each of the fields that were added to the `PaymentRequest`. The `validate()` functions returns a list of errors, which indicates any issues that have occured during validation. This list of errors can also be accessed by the `PaymentRequest.errorMessageIds` property. If there are no errors, the payment request can be encrypted and sent to our platform via your server. If there are validation errors, the customer should be provided with feedback about these errors.
```swift
// validate all fields in the payment request
let errorMessageIds = paymentRequest.validate()

// check if the payment request is valid
if errorMessageIds.count == 0 {
    // payment request is valid
} else {
    // payment request has errors
}
```

The validations are the `Validator`s linked to the `PaymentProductField` and are returned as a `ValidationError`, for example:
```swift
paymentRequest.errorMessageIds.forEach { error in
    // do something with the ValidationError, like displaying it to the user
}
```

#### Encrypt payment request

The `PaymentRequest` is ready for encryption once the `PaymentProduct` is set, the `PaymentProductField` values have been provided and validated, and potentially the selected `AccountOnFile` or `tokenize` properties have been set. The `PaymentRequest` encryption is done by using `session.prepare`. This will return a `PreparedPaymentRequest` which contains the encrypted payment request fields and encoded client meta info.
```swift
session.prepare(
    paymentRequest,
    success: { preparedPaymentRequest in
        // Forward the encryptedFields to your server
    },
    failure: { error in
        // Handle failure of encrypting Payment Request
    },
    apiFailure: { errorResponse in
        // Handle API failure of encrypting Payment Request
    }
)
```

> Although it is possible to use your own encryption algorithms to encrypt a payment request, we advise you to use the encryption functionality that is offered by the SDK.

### IINDetails

The first six digits of a payment card number are known as the *Issuer Identification Number (IIN)*. As soon as the first 6 digits of the card number have been captured, you can use the `session.iinDetails` call to retrieve the payment product and network that are associated with the provided IIN. Then you can verify the card type and check if you can accept this card.

An instance of `Session` can be used to check which payment product is associated with an IIN. This is done via the `session.iinDetails` function. The result of this check is an instance of `IINDetailsResponse`. This class has a property status that indicates the result of the check and a property `paymentProductId` that indicates which payment product is associated with the IIN. The returned `paymentProductId` can be used to provide visual feedback to the customer by showing the appropriate payment product logo.

The `IINDetailsResponse` has a status property represented through the `IINStatus` enum. The `IINStatus` enum values are:
- `supported` indicates that the IIN is associated with a payment product that is supported by our platform.
- `unknown` indicates that the IIN is not recognized.
- `notEnoughDigits"` indicates that fewer than six digits have been provided and that the IIN check cannot be performed.
- `existingButNotAllowed` indicates that the provided IIN is recognized, but that the corresponding product is not allowed for the current payment.
```swift
session.iinDetails(
    forPartialCreditCardNumber: "123456",
    context: paymentContext,
    success: { iinDetailsResponse in
        // check the status of the associated payment product
        let iinStatus = iinDetailsResponse.status
    },
    failure: { error in
        // Handle failure of retrieving IIN details
    },
    apiFailure: { errorResponse in
        // Handle API failure of retrieving IIN details
    }
)
```

Some cards are dual branded and could be processed as either a local card _(with a local brand)_ or an international card _(with an international brand)_. In case you are not setup to process these local cards, this API call will not return that card type in its response.

### StringFormatter

To help in formatting field values based on masks, the SDK offers the `StringFormatter` class. It allows you to format field values and apply and unapply masks on a string.
```swift
let formatter = StringFormatter()

let mask = "{{9999}} {{9999}} {{9999}} {{9999}}"
let value = "1234567890123456"

// apply masked value
let maskedValue = formatter.formatString(string: value, mask: mask) // "1234 5678 9012 3456"

// remove masked value
let unmaskedValue = formatter.unformatString(string: value, mask: mask) // "1234567890123456"
```

## Payment Steps

Setting up and completing a payment using the Swift SDK involves the following steps:

### 1. Initialize the Swift SDK for this payment

This is done using information such as session and customer identifiers, connection URLs and payment context information like currency and total amount.
```swift
let session = Session(
    clientSessionId: "47e9dc332ca24273818be2a46072e006",
    customerId: "9991-0d93d6a0e18443bd871c89ec6d38a873",
    baseURL: "https://clientapi.com",
    assetBaseURL: "https://assets.com",
    appIdentifier: "Swift Example Application/v2.0.4",
    loggingEnabled: true // set this to false in production
)

let amountOfMoney = AmountOfMoney(
    totalAmount: 1298, // in cents
    currencyCode: "EUR" // ISO 4217 currency code
)

let paymentContext = PaymentContext(
    amountOfMoney: amountOfMoney,
    isRecurring: false, // true, if it is a recurring payment
    countryCode: "NL" // ISO 3166-1 alpha-2 country code
)
```

> A successful response from Create Session can be used directly as input for the Session constructor.
- `clientSessionId` / `customerId` properties are used to authentication purposes. These can be obtained your server, using one of our available Server SDKs.
- The `baseURL` and `assetBaseURL` are the URLs the SDK should connect to. The SDK communicates with two types of servers to perform its tasks. One type of server offers the Client API as discussed above. And the other type of server stores the static resources used by the SDK, such as the logos of payment products.
- Payment information (`paymentContext`) is not needed to construct a session, but you will need to provide it when requesting any payment product information. The payment products that the customer can choose from depend on the provided payment information, so the Client SDK needs this information to be able to do its job. The payment information that is needed is:
    - the total amount of the payment, defined as property `amountOfMoney.totalAmount`
    - the currency that should be used, defined as property `amountOfMoney.currencyCode`
    - the country of the person that is performing the payment, defined as property `countryCode`
    - whether the payment is a single payment or a recurring payment

### 2. Retrieve the payment items

Retrieve the payment products and accounts on file that can be used for this payment. Your application can use this data to create the payment product selection screen.
```swift
session.paymentItems(
    for: paymentContext,
    groupPaymentProducts: false,
    success: { paymentItems in
        // Display the contents of paymentItems & accountsOnFile to your customer
    },
    failure: { error in
        // Inform the customer that something went wrong while retrieving the available Payment Products
    },
    apiFailure: { errorResponse in
        // Inform the customer that the API threw an error while retrieving the available Payment Products
    }
)
```

For some payment products, customers can indicate that they want the Online Payments platform to store part of the data they entered while using such a payment product. For example, it is possible to store the card holder name and the card number for most credit card payment products. The stored data is referred to as an `AccountOnFile` or token. `AccountOnFile` IDs available for the current payment must be provided in the request body of the Server API's Create Client Session call. When the customer wants to use the same payment product for another payment, it is possible to select one of the stored accounts on file for this payment. In this case, the customer does not have to enter the information that is already stored in the `AccountOnFile`. The list of available payment products that the SDK receives from the Client API also contains the accounts on file for each payment product. Your application can present this list of payment products and accounts on file to the customer.

If the customer wishes to use an existing `AccountOnFile` for a payment, the selected `AccountOnFile` should be added to the `PaymentRequest`.

### 3. Retrieve payment product details

Retrieve all the details about the payment product - including it's fields - that the customer needs to provide based on the selected payment product or account on file. Your app can use this information to create the payment product details screen.
```swift
session.paymentProduct(
    withId: "1", // replace with the id of the payment product that should be fetched
    context: paymentContext,
    success: { paymentProduct in
        // Display the fields to your customer
    },
    failure: { error in
        // Handle failure of retrieving a Payment Product by id
    },
    apiFailure: { errorResponse in
        // Handle API failure of retrieving a Payment Product by id
    }
)
```

Once the customer has selected a payment product or stored account on file, the SDK can request which information needs to be provided by the customer in order to perform a payment. When a single product is retrieved, the SDK provides a list of all the fields that should be rendered, including display hints and validation rules. If the customer selected an account on file, information that is already in this account on file can be prefilled in the input fields, instead of requesting it from the customer. The data that can be stored and prefilled on behalf of the customer is of course in line with applicable regulations. For instance, for a credit card transansaction the customer is still expected to input the CVC. The details entered by the customer are stored in a `PaymentRequest`. Again, the example app can be used as the starting point to create your screen. If there is no additional information that needs to be entered, this screen can be skipped. 

### 4. Encrypt payment information

Encrypt all the provided payment information in the `PaymentRequest` using `session.prepare`. This function will return a `PreparedPaymentRequest` which contains the encrypted payment request fields and encoded client meta info. The encrypted fields result is in a format that can be processed by the Server API. The only thing you need to provide to the SDK are the values the customer provided in your screens. Once you have retrieved the encrypted fields String from the `PreparedPaymentRequest`, your application should send it to your server, which in turn should forward it to the Server API.
```swift
session.prepare(
    paymentRequest,
    success: { preparedPaymentRequest in
        // Forward the encryptedFields to your server
    },
    failure: { error in
        // Handle failure of encrypting Payment Request
    },
    apiFailure: { errorResponse in
        // Handle API failure of encrypting Payment Request
    }
)
```

All the heavy lifting, such as requesting a public key from the Client API, performing the encryption and BASE-64 encoding the result into one string, is done for you by the SDK. You only need to make sure that the `PaymentRequest` object contains all the information entered by the user.

From your server, make a create payment request, providing the encrypted data in the `encryptedCustomerInput` field.

### 5. Response from the Server API call
It is up to you and your application to show the customer the correct screens based on the response of the Server API call. In some cases, the payment has not finished yet since the customer must be redirected to a third party (such as a bank or PayPal) to authorise the payment. See the Server API documentation on what kinds of responses the Server API can return. The Client API has no part in the remainder of the payment.

