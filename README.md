# Online Payments - Flutter SDK

The Online Payments Flutter SDK helps you with accepting payments in your Flutter app through the Online Payments platform.

The SDK's main function is to provide an integration with both the Android and Swift native Online Payments SDKs in a single Flutter library. 
The native SDKs establish a secure channel between your app and our server. This channel processes security credentials to guarantee the safe transit of your customers' data during the payment process.

**The Online Payments SDK helps you with:**
- Handling encryption of the payment context
- Convenient Dart wrappers for API responses
- User-friendly formatting of payment data, such as card numbers and expiry dates
- Validating user input
- Determining the card's associated payment provider

## Table of Contents
- [Online Payments - Flutter SDK](#online-payments---flutter-sdk)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
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
    - [Masking](#masking)
  - [Payment Steps](#payment-steps)
    - [1. Initialize the Flutter SDK for this payment](#1-initialize-the-flutter-sdk-for-this-payment)
    - [2. Retrieve the payment items](#2-retrieve-the-payment-items)
    - [3. Retrieve payment product details](#3-retrieve-payment-product-details)
    - [4. Encrypt payment information](#4-encrypt-payment-information)
    - [5. Response from the Server API call](#5-response-from-the-server-api-call)

## Installation

Add a dependency to the SDK in your app's `pubspec.yaml` file, where `x.y.z` is the version number:

    dependencies:
        // other dependencies
        online_payments_sdk: ^x.y.z

Afterwards, run the following command:
`flutter pub get`

### Android

Make sure you enable multidex support in your `build.gradle` file if `minSdkVersion` is set to 20 or lower:
```gradle
defaultConfig {
    ...
    multiDexEnabled true
    ...
}

dependencies {
    ...
    implementation 'androidx.multidex:multidex:2.0.1'
    ...
}
```

## Getting started

To accept your first payment using the SDK, complete the steps below. Also see the section [Payment Steps](#payment-steps) for more details on these steps.

1. Request your server to create a Client Session, using one of our available Server SDKs. Return the session details to your app.
2. Initialize the SDK using the session details.
```dart
Session session = Session(
    "47e9dc332ca24273818be2a46072e006", // client session id
    "9991-0d93d6a0e18443bd871c89ec6d38a873", // customer id
    "https://clientapi.com", // client API URL
    "https://assets.com", // asset URL
    isEnvironmentProduction: false, // states if the environment is production, this property is used to determine the Google Pay environment
    appIdentifier: "Flutter Example Application/v1.0.0", // application identifier
    loggingEnabled: true // Controls whether logging is enabled - use for development purposes.
);
```
3. Configure your payment context.
```dart
AmountOfMoney amountOfMoney = AmountOfMoney(
    1298, // in cents
    "EUR" // three letter currency code as defined in ISO 4217
);

PaymentContext paymentContext = PaymentContext(
    amountOfMoney,
    "NL", // two letter country code as defined in ISO 3166-1 alpha-2
    false // true, if it is a recurring payment
);
```
4. Retrieve the available Payment Products. To handle retrieving the Payment Products and any possible errors, you will have to use the `BasicPaymentProductsResponseListener`. After successfully retrieving the Payment Products, display the `BasicPaymentItem` and `AccountOnFile` lists and request your customer to select one.
```dart
BasicPaymentProductsResponseListener basicPaymentProductsResponseListener = BasicPaymentProductsResponseListener (
    onSuccess: (response) {
      // Display the contents of basicPaymentItems & accountsOnFile to your customer
    },
    onError: (apiError) {
      // Inform the customer that something went wrong while retrieving the available Payment Products
    },
    onException: (throwable) {
      // Inform the customer that something went wrong while retrieving the available Payment Products
    }
);

await session.getBasicPaymentProducts(
    request: BasicPaymentProductsRequest(paymentContext: paymentContext),
    listener: basicPaymentProductsResponseListener, // listener to be called when payment items are retrieved or an error occured
);
```
5. Once the customer has selected the desired payment product, retrieve the enriched `PaymentProduct` detailing what information the customer needs to provide to authorize the payment. To handle retrieving the enriched `PaymentProduct` and any possible errors, you will have to use the `PaymentProductResponseListener`. After successfully retrieving the `PaymentProduct`, display the required information fields to your customer.
```dart
PaymentProductResponseListener paymentProductResponseListener = PaymentProductResponseListener(
    onSuccess: (response) {
      // Display the fields to your customer
    },
    onError: (apiError) {
      // Inform the customer that something went wrong while retrieving the available Payment Products
    },
    onException: (throwable) {
      // Inform the customer that something went wrong while retrieving the available Payment Products
    }
);

await session.getPaymentProduct(
    request: PaymentProductRequest(
      productId: "1", // id of the payment product you want to retrieve
      paymentContext: paymentContext // PaymentContext
    ),
    listener: paymentProductResponseListener // listener to be called when the payment product is retrieved or an error occured
);
```
6. Save the customer's input for the required information fields in a `PaymentRequest`.
```dart
PaymentRequest paymentRequest = PaymentRequest(
    paymentProduct: paymentProduct, // Product for which the request will be made
    tokenize: false // Flag for tokenizing the request
);

paymentRequest.setValue(
    "cardNumber", // field id
    "1245 1254 4575 45" // value
);
paymentRequest.setValue("cvv", "123");
paymentRequest.setValue("expiryDate", "12/25");
```
7. Validate and encrypt the payment request. To handle encrypting the `PaymentRequest`, you will have to use the `PaymentRequestPreparedListener`. After successfully encrypting the `PaymentRequest`, you will have access to the encrypted version, `PreparedPaymentRequest`. The encrypted customer data should then be sent to your server.
```dart
PaymentRequestPreparedListener paymentRequestPreparedListener = PaymentRequestPreparedListener (
    onSuccess: (response) {
      // Forward the encryptedFields to your server
    },
    onError: (apiError) {
      // Encrypting the request failed
    },
    onException: (throwable) {
      // Encrypting the request failed
    }
);

await session.preparePaymentRequest(
    request: paymentRequest, // the payment request that should be encrypted
    listener: paymentRequestPreparedListener // listener to be called when the payment request is encrypted
);
```
8. Request your server to create a payment request, using the Server API's Create Payment call. Provide the encrypted data in the `encryptedCustomerInput` field.

## Type definitions
### Session

For all interactions with the SDK an instance of `Session` is required. The following code fragment shows how `Session` is initialized. The session details are obtained by performing a Create Client Session call using the Server API.
```dart
Session session = Session(
    "47e9dc332ca24273818be2a46072e006", // client session id
    "9991-0d93d6a0e18443bd871c89ec6d38a873", // customer id
    "https://clientapi.com", // client API URL
    "https://assets.com", // asset URL
    isProductionEnvironment: false, // states if the environment is production, this property is used to determine the Google Pay environment
    appIdentifier: "Flutter Example Application/v1.0.0", // application identifier
    loggingEnabled: true // states whether you would like to enable logging of requests made to the server and responses received from the server
);
```
Almost all methods that are offered by `Session` are simple wrappers around the Client API. They make the request and convert the response to Dart objects that may contain convenience functions.

#### Logging of requests and responses
You are able to log requests made to the server and responses received from the server. By default logging is disabled, and it is important to always disable it in production. You are able to enable the logging in two ways. Either by setting its value when creating a Session - as shown in the code fragment above - or by setting its value after the Session was already created.
```dart
session.loggingEnabled = true;
```

### PaymentContext

`PaymentContext` is an object that contains the context/settings of the upcoming payment. It is required as an argument to some of the methods of the `Session` instance. This object can contain the following details:
```dart
class PaymentContext {
  AmountOfMoney amountOfMoney; // contains the total amount and the ISO 4217 currency code
  String countryCode; // ISO 3166-1 alpha-2 country code
  bool isRecurring; // Set `true` when payment is recurring. Default false.
  bool forceBasicFlow; // Set 'true' to force the basic flow. Default false.

  PaymentContext(
    this.amountOfMoney, this.countryCode, this.isRecurring, // Required unnamed constructor arguments
    { this.forceBasicFlow = false } // Named optional constructor argument
  );
}
```

### PaymentItems
This object contains the available Payment Items for the current payment. Use the `session.getBasicPaymentItems` function to request the data. To handle retrieving the Payment Products and any possible errors, you will have to use the `BasicPaymentProductsResponseListener`. You can either let your class implement this listener or declare the listener as a property of your class.

The object you will receive is `BasicPaymentItems`, which contains two lists. One for all available `BasicPaymentItem`s and one for all available `AccountOnFile`s.

The code fragment below shows how to get the `BasicPaymentItems` instance.
```dart
BasicPaymentProductsResponseListener basicPaymentProductsResponseListener = BasicPaymentProductsResponseListener (
    onSuccess: (response) {
      // Display the contents of basicPaymentItems & accountsOnFile to your customer
    },
    onError: (apiError) {
      // Inform the customer that something went wrong while retrieving the available Payment Products
    },
    onException: (throwable) {
      // Inform the customer that something went wrong while retrieving the available Payment Products
    }
);

await session.getBasicPaymentProducts( 
    request: BasicPaymentProductsRequest(paymentContext: paymentContext), // Request
    listener: basicPaymentProductsResponseListener, // listener to be called when payment items are retrieved or an error occured
);
```

### BasicPaymentProduct

The SDK offers two types to represent information about payment products:
`BasicPaymentProduct` and `PaymentProduct`. Practically speaking, instances of `BasicPaymentProduct` contain only the information that is required to display a simple list of payment products from which the customer can select one.

The type `PaymentProduct` contains additional information, such as the specific form fields that the customer is required to fill out. This type is typically used when creating a form that asks the customer for their details. See the [PaymentProduct](#paymentproduct) section for more info.

Below is an example for how to obtain display names and assets for the Visa product.
```dart
BasicPaymentProduct basicPaymentProduct = basicPaymentProducts.getBasicPaymentProductById("1");

String id = basicPaymentProduct.id;
String? label = basicPaymentProduct.displayHintsList.firstOrNull?.label;
String? logoUrl = basicPaymentProduct.displayHintsList.firstOrNull?.logo;
```

### AccountOnFile

An instance of `AccountOnFile` represents information about a stored card product for the current customer. `AccountOnFile` IDs available for the current payment must be provided in the request body of the Server API's Create Client Session call. If the customer wishes to use an existing `AccountOnFile` for a payment, the selected `AccountOnFile` should be added to the `PaymentRequest`. The code fragment below shows how display data for an account on file can be retrieved. This label can be shown to the customer, along with the logo of the corresponding payment product.
```dart
// All available accounts on file across all payment products
List<AccountOnFile> allAccountsOnFile = basicPaymentProducts.accountsOnFile;

// All available accounts on file for a specific payment product
BasicPaymentProduct basicPaymentProduct = basicPaymentProducts.getBasicPaymentProductById("1");
List<AccountOnFile> allAccountsOnFile = basicPaymentProduct.accountsOnFile;

// Get specific account on file for the payment product
AccountOnFile accountOnFile = null;

for(AccountOnFile aof in basicPaymentProduct.accountsOnFile) {
    if (aof.id == identifier) { // 'identifier' is the ID of the AccountOnFile selected by the customer
        accountOnFile = aof;
        break;
    }
}

// Shows a mask based formatted value for the obfuscated cardNumber.
// The mask that is used is defined in the displayHints of this accountOnFile
// If the mask for the "cardNumber" field is {{9999}} {{9999}} {{9999}} {{9999}} {{999}}, then the result would be **** **** **** 7412
String maskedValue = await accountOnFile.getMaskedValue("cardNumber");
```

### PaymentProduct

`BasicPaymentProduct` only contains the information required by a customer to distinguish one payment product from another. However, once a payment product or an account on file has been selected, the customer must provide additional information, such as a bank account number, a credit card number, or an expiry date, before a payment can be processed. Each payment product can have several fields that need to be completed to process a payment. Instances of `BasicPaymentProduct` do not contain any information about these fields.

Information about the fields of payment products are represented by instances of `PaymentProductField`, which are contained in instances of `PaymentProduct`. The class `PaymentProductField` is described further down below. To handle retrieving the desired `PaymentProduct` and any possible errors, you will have to use the `PaymentProductsResponseListener`. You can either let your class implement this listener or declare the listener as a property of your class.

The `Session` instance can be used to retrieve instances of `PaymentProduct`, as shown in the following code fragment.
```dart
PaymentProductResponseListener paymentProductResponseListener = PaymentProductResponseListener (
    onSuccess: (response) {
      // Display the fields to your customer
    },
    onError: (apiError) {
      // Inform the customer that something went wrong while retrieving the Payment Product
    },
    onException: (throwable) {
      // Inform the customer that something went wrong while retrieving the Payment Product
    }
);

await session.getPaymentProduct(
    request: PaymentProductRequest(
      productId: "1", // id of the payment product you want to retrieve
      paymentContext: paymentContext // PaymentContext
    ),
    listener: paymentProductResponseListener // listener to be called when the payment product is retrieved or an error occured
);
```

### PaymentProductField

The fields of payment products are represented by instances of `PaymentProductField`. Each field has an identifier, a type, a definition of restrictions that apply to the value of the field, and information about how the field should be presented graphically to the customer. Additionally, an instance of a field can be used to determine whether a given value is valid for the field.

In the code fragment below, the field with identifier `"cvv"` is retrieved from a payment product. The data restrictions of the field are inspected to see whether the field is a required field or an optional field. Additionally, the display hints of the field are inspected to see whether the values a customer provides should be obfuscated in a user interface.
```dart
PaymentProductField ccvField = paymentProduct.getPaymentProductFieldById("cvv");

bool isRequired = ccvField.dataRestrictions.isRequired; // state if value is required for this field
bool shouldObfuscate = ccvField.displayHints?.obfuscate; // state if field value should be obfuscated
```

### PaymentRequest

Once a payment product has been selected and an instance of `PaymentProduct` has been retrieved, a payment request can be constructed. This class must be used as a container for all the values the customer provides.
```dart
PaymentRequest paymentRequest = PaymentRequest(
  paymentProduct: paymentProduct,
  tokenize: true, // Optional argument to tokenize the request - default is false
  accountOnFile: accountOnFile // Optional argument to set the accountOnFile to be used for the paymentRequest
);
```

#### Tokenize payment request
A `PaymentProduct` has a property `tokenize`, which is used to indicate whether a payment request should be stored as an account on file. The code fragment below shows how a payment request should be constructed when the request should be stored as an account on file. By default, `tokenize` is set to `false`.
```dart
PaymentRequest paymentRequest = PaymentRequest(
    paymentProduct: paymentProduct,
);
// you can set the request's tokenize property after having initialized the paymentRequest
paymentRequest.tokenize = true;
```

If the customer selected an account on file, both the account on file and the corresponding payment product must be supplied while constructing the payment request, as shown in the code fragment below. Instances of `AccountOnFile` can be retrieved from instances of `BasicPaymentProduct` and `PaymentProduct`.
```dart
// you can supply accountOnFile via the constructor
PaymentRequest paymentRequest = PaymentRequest(
  paymentProduct: paymentProduct,
  accountOnFile: accountOnFile
);

// or by accessing the request's accountOnFile property
paymentRequest.accountOnFile = accountOnFile;
```

#### Set field values to payment request

Once a payment request has been configured, the value for the payment product's fields can be supplied as shown below. The identifiers of the fields, such as "cardNumber" and "cvv" in the example below, are used to set the values of the fields using the payment request.
```dart
PaymentRequest paymentRequest = PaymentRequest(
  paymentProduct: paymentProduct,
);
paymentRequest.setValue(
    "cardNumber", // field id
    "1245 1254 4575 45" // value
);
paymentRequest.setValue("cvv", "123");
paymentRequest.setValue("expiryDate", "12/25");
```

#### Validate payment request

Once all values have been supplied, the payment request can be validated. Behind the scenes the validation uses the `DataRestrictions` class for each of the fields that were added to the `PaymentRequest`. After the validation, a list of errors is available, which indicates any issues that have occured during validation. If there are no errors, the payment request can be encrypted and sent to our platform via your erver. If there are validation errors, the customer should be provided with feedback about these errors.
```dart
// Validate all fields in a Payment Request
List<ValidationErrorMessage> errorMessages = await paymentRequest.validate();
// check if the payment request is valid
if (errorMessages.isEmpty) {
// payment request is valid
} else {
// payment request has errors
} 
```

The validations are the `Validator`s linked to the `PaymentProductField` and are returned as a `ValidationErrorMessage`, for example:
```dart
for (ValidationErrorMessage validationResult in errorMessages) {
    // do something with the error, like displaying it to the user
}
```

#### Encrypt payment request

The `PaymentRequest` is ready for encryption once the `PaymentProduct` is set, the `PaymentProductField` values have been provided and validated, and potentially the selected `AccountOnFile` or `tokenize` properties have been set. The `PaymentRequest` encryption is done by using `session.prepare`. To handle the result of the encrypted `PaymentRequest`, you will have to use the `PaymentRequestPreparedListener`. After successfully encrypting the `PaymentRequest`, you will have access to the encrypted version, `PreparedPaymentRequest` which contains the encrypted payment request fields and encoded client meta info.
```dart
PaymentRequestPreparedListener paymentRequestPreparedListener = PaymentRequestPreparedListener(
    onSuccess: (response) {
      // Forward the encryptedFields to your server
    },
    onError: (apiError) {
      // Something went wrong in retrieving the key to encrypt your payment request
    },
    onException: (throwable) {
      // Something went wrong while encrypting your payment request
    }
);

await session.preparePaymentRequest(
    request : SdkPreparePaymentRequest(paymentRequest), // The req payment request that should be encrypted
    listener : paymentRequestPreparedListener // listener to be called when the payment request is encrypted
);
```

> Although it is possible to use your own encryption algorithms to encrypt a payment request, we advise you to use the encryption functionality that is offered by the SDK.

### IINDetails

The first six digits of a payment card number are known as the *Issuer Identification Number (IIN)*. As soon as the first 6 digits of the card number have been captured, you can use the `session.getIinDetails` call to retrieve the payment product and network that are associated with the provided IIN. Then you can verify the card type and check if you can accept this card.

An instance of `Session` can be used to check which payment product is associated with an IIN. This is done via the `session.getIinDetails` function. The result of this check is an instance of `IinDetailsResponse`. This class has a property status that indicates the result of the check and a property `paymentProductId` that indicates which payment product is associated with the IIN. The returned `paymentProductId` can be used to provide visual feedback to the customer by showing the appropriate payment product logo.


The `IinDetailsResponse` has a status property represented through the `IinStatus` enum. The `IinStatus` enum values are:
- `SUPPORTED` indicates that the IIN is associated with a payment product that is supported by our platform.
- `UNKNOWN` indicates that the IIN is not recognized.
- `NOT_ENOUGH_DIGITS` indicates that fewer than six digits have been provided and that the IIN check cannot be performed.
- `EXISTING_BUT_NOT_ALLOWED` indicates that the provided IIN is recognized, but that the corresponding product is not allowed for the current payment.

To handle retrieving the desired `IinDetailsResponse` and any possible errors, you will have to use the `IinLookupResponseListener`. You can either let your class implement this listener or declare the listener as a property of your class.
```dart
IinLookupResponseListener iinLookupResponseListener = IinLookupResponseListener(
    onSuccess: (response) {
      // check the status of the associated payment product
      IinStatus iinStatus = response.status;
    },
    onError: (apiError) {
      // Handle apiError of retrieving IIN details
    },
    onException: (throwable) {
      // Handle exception while retrieving IIN details
    }
);

await session.getIinDetails(
  request: IinDetailsRequest(
    partialCreditCardNumber: "123456",
    paymentContext: paymentContext // The payment context
  ),
  listener: iinLookupResponseListener // listener to be called when iin details are retrieved or an error occured
);
```

Some cards are dual branded and could be processed as either a local card _(with a local brand)_ or an international card _(with an international brand)_. In case you are not setup to process these local cards, this API call will not return that card type in its response.

### Masking 

To help in formatting field values based on masks, the SDK offers functionality on `AccountOnFile`, `PaymetRequest` and `PaymentProductField`. It allows you to format field values and apply and unapply masks on a string.

```dart
// apply masked value
String maskedValue = await paymentRequest.getMaskedValue("cardNumber"); // "1234 5678 9012 3456"

// remove masked value
String unmaskedValue = await paymentRequest.getUnmaskedValue("cardNumber"); // "1234567890123456"
```

## Payment Steps

Setting up and completing a payment using the Flutter SDK involves the following steps:

### 1. Initialize the Flutter SDK for this payment

This is done using information such as session and customer identifiers, connection URLs and payment context information like currency and total amount.
```dart
Session session = Session(
    "47e9dc332ca24273818be2a46072e006", // client session id
    "9991-0d93d6a0e18443bd871c89ec6d38a873", // customer id
    "https://clientapi.com", // client API URL
    "https://assets.com", // asset URL
    isEnvironmentProduction: false, // states if the environment is production, this property is used to determine the Google Pay environment
    appIdentifier: "Flutter Example Application/v1.0.0", // application identifier
    loggingEnabled: true // States if logging is enabled
);

AmountOfMoney amountOfMoney = AmountOfMoney(
    1298, // in cents as int
    "EUR" // three letter currency code as defined in ISO 4217
);

PaymentContext paymentContext = PaymentContext(
    amountOfMoney,
    "NL", // two letter country code as defined in ISO 3166-1 alpha-2
    false // true, if it is a recurring payment
);
```

> A successful response from Create Session can be used directly as input for the Session constructor.
- `clientSessionId` / `customerId` properties are used to authentication purposes. These can be obtained your server, using one of our available Server SDKs.
- The `clientApiUrl` and `assetBaseUrl` are the URLs the SDK should connect to. The SDK communicates with two types of servers to perform its tasks. One type of server offers the Client API as discussed above. And the other type of server stores the static resources used by the SDK, such as the logos of payment products.
- Payment information (`paymentContext`) is not needed to construct a session, but you will need to provide it when requesting any payment product information. The payment products that the customer can choose from depend on the provided payment information, so the Client SDK needs this information to be able to do its job. The payment information that is needed is:
    - the total amount of the payment, defined as property `amountOfMoney.amount`
    - the currency that should be used, defined as property `amountOfMoney.currencyCode`
    - the country of the person that is performing the payment, defined as property `countryCode`
    - whether the payment is a single payment or a recurring payment

### 2. Retrieve the payment items

Retrieve the payment products and accounts on file that can be used for this payment. Your application can use this data to create the payment product selection screen.
```dart
BasicPaymentProductsResponseListener basicPaymentProductsResponseListener = BasicPaymentProductsResponseListener (
    onSuccess: (response) {
      // Display the contents of basicPaymentItems & accountsOnFile to your customer
    },
    onError: (apiError) {
      // Inform the customer that something went wrong while retrieving the available Payment Products
    },
    onException: (throwable) {
      // Inform the customer that something went wrong while retrieving the available Payment Products
    }
);

await session.getBasicPaymentProducts(
  request: BasicPaymentProductsRequest(paymentContext: paymentContext), // Request
  listener: basicPaymentProductsResponseListener, // listener to be called when payment items are retrieved or an error occured
);
```

For some payment products, customers can indicate that they want the Online Payments platform to store part of the data they entered while using such a payment product. For example, it is possible to store the card holder name and the card number for most credit card payment products. The stored data is referred to as an `AccountOnFile` or token. `AccountOnFile` IDs available for the current payment must be provided in the request body of the Server API's Create Client Session call. When the customer wants to use the same payment product for another payment, it is possible to select one of the stored accounts on file for this payment. In this case, the customer does not have to enter the information that is already stored in the `AccountOnFile`. The list of available payment products that the SDK receives from the Client API also contains the accounts on file for each payment product. Your application can present this list of payment products and accounts on file to the customer.

If the customer wishes to use an existing `AccountOnFile` for a payment, the selected `AccountOnFile` should be added to the `PaymentRequest`.

### 3. Retrieve payment product details

Retrieve all the details about the payment product - including it's fields - that the customer needs to provide based on the selected payment product or account on file. Your app can use this information to create the payment product details screen.
```dart
PaymentProductResponseListener paymentProductResponseListener = PaymentProductResponseListener (
    onSuccess: (response) {
      // Display the fields to your customer
    },
    onError: (apiError) {
      // Inform the customer that something went wrong while retrieving the Payment Product
    },
    onException: (throwable) {
      // Inform the customer that something went wrong while retrieving the Payment Product
    }
);

await session.getPaymentProduct(
  request: PaymentProductRequest(
    productId: "1", 
    paymentContext: paymentContext
  ),
  listener: paymentProductResponseListener // listener to be called when the payment product is retrieved or an error occured
);
```

Once the customer has selected a payment product or stored account on file, the SDK can request which information needs to be provided by the customer in order to perform a payment. When a single product is retrieved, the SDK provides a list of all the fields that should be rendered, including display hints and validation rules. If the customer selected an account on file, information that is already in this account on file can be prefilled in the input fields, instead of requesting it from the customer. The data that can be stored and prefilled on behalf of the customer is of course in line with applicable regulations. For instance, for a credit card transansaction the customer is still expected to input the CVC. The details entered by the customer are stored in a `PaymentRequest`. Again, the example app can be used as the starting point to create your screen. If there is no additional information that needs to be entered, this screen can be skipped.

### 4. Encrypt payment information

Encrypt all the provided payment information in the `PaymentRequest` using `session.preparePaymentRequest`. This function will return a `PreparedPaymentRequest` which contains the encrypted payment request fields and encoded client meta info. The encrypted fields result is in a format that can be processed by the Server API. The only thing you need to provide to the SDK are the values the customer provided in your screens. Once you have retrieved the encrypted fields String from the `PreparedPaymentRequest`, your application should send it to your server, which in turn should forward it to the Server API.
```dart
PaymentRequestPreparedListener paymentRequestPreparedListener = PaymentRequestPreparedListener(
    onSuccess: (response) {
      // Forward the encryptedFields to your server
    },
    onError: (apiError) {
      // Something went wrong in retrieving the key to encrypt your payment request
    },
    onException: (throwable) {
      // Something went wrong while encrypting your payment request
    }
);

await session.preparePaymentRequest(
  request : SdkPreparePaymentRequest(paymentRequest), // The req payment request that should be encrypted
  listener : paymentRequestPreparedListener // listener to be called when the payment request is encrypted
);
```

All the heavy lifting, such as requesting a public key from the Client API, performing the encryption and BASE-64 encoding the result into one string, is done for you by the SDK. You only need to make sure that the `PaymentRequest` object contains all the information entered by the user.

From your server, make a create payment request, providing the encrypted data in the `encryptedCustomerInput` field.

### 5. Response from the Server API call
It is up to you and your application to show the customer the correct screens based on the response of the Server API call. In some cases, the payment has not finished yet since the customer must be redirected to a third party (such as a bank or PayPal) to authorise the payment. See the Server API documentation on what kinds of responses the Server API can return. The Client API has no part in the remainder of the payment.
