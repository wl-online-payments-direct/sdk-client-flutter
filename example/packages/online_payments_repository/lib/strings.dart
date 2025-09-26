/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2025 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
/// Input page
const String appIdentifier = "Online Payments Flutter Example";
const String paymentContextInfo =
    "The product will be retrieved for the following payment context:";
const String paymentContextAmount = "Amount: ";
const String paymentContextCurrencyCode = "Currency code: ";
const String paymentContextCountryCode = "Country code: ";
const String clientSessionDetailsHeader = "Client session details";
const String clientSessionIdLabel = "Client session ID";
const String clientSessionIdTooltip =
    "Returned in the Server to Server Create Client Session call. This is the identifier of the current session.";
const String customerIdLabel = "Customer ID";
const String customerIdTooltip =
    "Returned in the Server to Server Create Client Session call. This is a temporary identifier for you within the session.";
const String clientApiUrlLabel = "Client API URL";
const String clientApiUrlTooltip =
    "Returned in the Server to Server Create Client Session call. This URL points to the Online Payments Client API.";
const String assetsUrlLabel = "Assets URL";
const String assetsUrlTooltip =
    "Returned in the Server to Server Create Client Session call. This URL can be used to retrieve static resources, such as payment product logo images.";
const String paymentProductIdLabel = "Payment product ID";
const String paymentProductIdTooltip =
    "The id of the Payment Product which should be retrieved.";
const String retrievePaymentProductButtonLabel = "Retrieve payment product";
const String pasteSessionDataButtonLabel = "Paste Session Data";

/// Payment Product page
const String productIdLabel = "Payment product ID:";
const String paymentMethodLabel = "Payment method:";
const String paymentProductGroupLabel = "Payment product group:";
const String allowsRecurringLabel = "Allows recurring:";
const String allowsTokenizationLabel = "Allows tokenization:";
const String usesRedirectionThirdPartyLabel = "Uses redirection to 3rd party:";
const String displayHintsListLabel = "Display hints list";
const String displayOderLabel = "Display order:";
const String labelLabel = "Label:";
const String logoLabel = "Logo:";
const String specific302DataLabel = "Apple Pay specific data";
const String specific320DataLabel = "Google Pay specific data";
const String networksLabel = "Networks:";
const String gatewayLabel = "Gateway:";
const String accountsOnFileLabel = "Accounts on file";
const String accountOnFileIdLabel = "Account on file ID:";
const String attributesLabel = "Attributes";
const String keyLabel = "Key:";
const String statusLabel = "Status:";
const String valueLabel = "Value:";
const String displayHintsLabelTemplatesLabel =
    "Display hints - label templates";
const String attributeKeyLabel = "Attribute key:";
const String maskLabel = "Mask:";
const String paymentProductFieldsLabel = "Payment product fields";
const String paymentProductFieldLabel = "Payment product field";
const String paymentProductFieldIdLabel = "Payment product field ID:";
const String typeLabel = "Type:";
const String dataRestrictionsLabel = "Data restrictions";
const String requiredLabel = "Required:";
const String validationRulesLabel = "Validation rules:";
const String displayHintsLabel = "Display hints";
const String alwaysShowLabel = "Always show:";
const String formElementTypeLabel = "Form element type:";
const String obfuscateLabel = "Obfuscate:";
const String placeholderLabel = "Placeholder:";
const String preferredInputTypeLabel = "Preferred input type:";
const String tooltipLabel = "Tooltip label:";

/// OK dialog
const String okLabel = "OK";

/// Errors
const String apiErrorTitle = "API error";
const String nativeExceptionTitle = "Native exception";
const String emptyFieldValidationMessage = "This field should not be empty";
const String paymentProductNotFound =
    "No payment product retrieved, please try again with a different product id";
const String paymentProductLabelNotFound = "No label found";
