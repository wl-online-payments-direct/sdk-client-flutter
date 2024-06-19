/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2023 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

void main() {
  Future<Map<String, dynamic>> jsonMap(String filename) async {
    final file = File(filename);
    return jsonDecode(await file.readAsString());
  }

  test('deserializePublicKey', () async {
    final PublicKey deserializedPublicKey = PublicKey.fromJson(
        await jsonMap("test/mock_responses/public_key_response.json"));

    expect(deserializedPublicKey.keyId, "TestKeyId");
    expect(deserializedPublicKey.publicKey, "t3stP0bl1cK3y");
  });

  test('deserializeIinDetails', () async {
    final IinDetailsResponse deserializedIinDetails =
        IinDetailsResponse.fromJson(
            await jsonMap("test/mock_responses/iin_details_response.json"));

    expect(deserializedIinDetails.status, IinStatus.supported);
    expect(deserializedIinDetails.coBrands.length, 2);
    expect(deserializedIinDetails.coBrands[0].isAllowedInContext, true);
    expect(deserializedIinDetails.coBrands[0].cardType, CardType.debit);
    expect(deserializedIinDetails.coBrands[0].paymentProductId, "3");
    expect(deserializedIinDetails.coBrands[1].isAllowedInContext, false);
    expect(deserializedIinDetails.coBrands[1].cardType, CardType.prepaid);
    expect(deserializedIinDetails.coBrands[1].paymentProductId, "119");
    expect(deserializedIinDetails.countryCode, "US");
    expect(deserializedIinDetails.isAllowedInContext, true);
    expect(deserializedIinDetails.paymentProductId, "3");
    expect(deserializedIinDetails.cardType, CardType.credit);
  });

  test('deserializeBasicPaymentProducts', () async {
    final BasicPaymentProducts deserializedBasicPaymentProducts =
        BasicPaymentProducts.fromJson(await jsonMap(
            "test/mock_responses/basic_payment_products_response.json"));

    expect(deserializedBasicPaymentProducts.products.length, 3);
    expect(
        deserializedBasicPaymentProducts.products[0].accountsOnFile.length, 0);
    expect(deserializedBasicPaymentProducts.products[0].allowsRecurring, true);
    expect(
        deserializedBasicPaymentProducts.products[0].allowsTokenization, true);
    expect(deserializedBasicPaymentProducts.products[0].displayHintsList.length,
        1);
    expect(
        deserializedBasicPaymentProducts
            .products[0].displayHintsList[0].displayOrder,
        0);
    expect(
        deserializedBasicPaymentProducts.products[0].displayHintsList[0].label,
        "American Express");
    expect(
        deserializedBasicPaymentProducts
            .products[0].displayHintsList[0].logoUrl,
        "American_Express_logo");
    expect(deserializedBasicPaymentProducts.products[0].id, "2");
    expect(deserializedBasicPaymentProducts.products[0].paymentMethod, "card");
    expect(deserializedBasicPaymentProducts.products[0].paymentProductGroup,
        "Cards");
    expect(
        deserializedBasicPaymentProducts.products[0].usesRedirectionTo3rdParty,
        false);
    expect(
        deserializedBasicPaymentProducts
            .products[0].paymentProduct320SpecificData,
        isNull);
    expect(
        deserializedBasicPaymentProducts
            .products[0].paymentProduct302SpecificData,
        isNull);
  });

  test('deserializePaymentProductWithAccountOnFile', () async {
    final PaymentProduct deserializedPaymentProduct = PaymentProduct.fromJson(
        await jsonMap("test/mock_responses/payment_product_response.json"));

    expect(deserializedPaymentProduct.accountsOnFile.length, 1);
    expect(deserializedPaymentProduct.accountsOnFile[0].attributes.length, 4);
    expect(deserializedPaymentProduct.accountsOnFile[0].attributes[0].key,
        "cardholderName");
    expect(deserializedPaymentProduct.accountsOnFile[0].attributes[0].value,
        "Wile E. Coyote");
    expect(deserializedPaymentProduct.accountsOnFile[0].attributes[0].status,
        AccountOnFileAttributeStatus.readOnly);
    expect(
        deserializedPaymentProduct.accountsOnFile[0].attributes[2].key, "cvv");
    expect(deserializedPaymentProduct.accountsOnFile[0].attributes[2].value,
        "111");
    expect(deserializedPaymentProduct.accountsOnFile[0].attributes[2].status,
        AccountOnFileAttributeStatus.canWrite);
    expect(deserializedPaymentProduct.accountsOnFile[0].id, "0");
    expect(deserializedPaymentProduct.accountsOnFile[0].paymentProductId, "3");
    expect(deserializedPaymentProduct.allowsRecurring, true);
    expect(deserializedPaymentProduct.allowsTokenization, true);
    expect(deserializedPaymentProduct.displayHintsList.length, 1);
    expect(deserializedPaymentProduct.displayHintsList[0].displayOrder, 0);
    expect(deserializedPaymentProduct.displayHintsList[0].label, "MasterCard");
    expect(deserializedPaymentProduct.displayHintsList[0].logoUrl,
        "MasterCard_logo");
    expect(deserializedPaymentProduct.fields.length, 4);
    expect(
        deserializedPaymentProduct.fields[0].dataRestrictions.isRequired, true);
    expect(
        deserializedPaymentProduct
            .fields[0].dataRestrictions.validationRules.length,
        3);
    expect(
        deserializedPaymentProduct
            .fields[0].dataRestrictions.validationRules[0].validationType,
        ValidationType.length);
    expect(
        (deserializedPaymentProduct.fields[0].dataRestrictions
                .validationRules[0] as ValidationRuleLength)
            .minLength,
        13);
    expect(
        (deserializedPaymentProduct.fields[0].dataRestrictions
                .validationRules[0] as ValidationRuleLength)
            .maxLength,
        19);
    expect(
        deserializedPaymentProduct.fields[0].displayHints?.alwaysShow, false);
    expect(deserializedPaymentProduct.fields[0].displayHints?.displayOrder, 0);
    expect(deserializedPaymentProduct.fields[0].displayHints?.formElement?.type,
        FormElementType.text);
    expect(deserializedPaymentProduct.fields[0].displayHints?.label,
        "Card number");
    expect(deserializedPaymentProduct.fields[0].displayHints?.mask,
        "{{9999}} {{9999}} {{9999}} {{9999}} {{999}}");
    expect(deserializedPaymentProduct.fields[0].displayHints?.obfuscate, false);
    expect(deserializedPaymentProduct.fields[0].displayHints?.placeholderLabel,
        "");
    expect(
        deserializedPaymentProduct.fields[0].displayHints?.preferredInputType,
        PreferredInputType.stringKeyboard);
    expect(
        deserializedPaymentProduct.fields[0].displayHints?.tooltip?.label, "");
    expect(deserializedPaymentProduct.fields[0].id, "cardNumber");
    expect(deserializedPaymentProduct.fields[0].type,
        PaymentProductFieldType.numericString);
    expect(deserializedPaymentProduct.id, "3");
    expect(deserializedPaymentProduct.paymentMethod, "card");
    expect(deserializedPaymentProduct.paymentProductGroup, "Cards");
    expect(deserializedPaymentProduct.usesRedirectionTo3rdParty, false);
    expect(deserializedPaymentProduct.paymentProduct320SpecificData, isNull);
    expect(deserializedPaymentProduct.paymentProduct302SpecificData, isNull);
  });

  test('deserializePaymentProductGooglePay', () async {
    final PaymentProduct deserializedPaymentProduct = PaymentProduct.fromJson(
        await jsonMap(
            "test/mock_responses/payment_product_response_googlepay.json"));

    expect(deserializedPaymentProduct.allowsRecurring, false);
    expect(deserializedPaymentProduct.allowsTokenization, false);
    expect(deserializedPaymentProduct.displayHintsList.length, 1);
    expect(deserializedPaymentProduct.displayHintsList[0].displayOrder, 0);
    expect(deserializedPaymentProduct.displayHintsList[0].label, "GOOGLEPAY");
    expect(deserializedPaymentProduct.displayHintsList[0].logoUrl,
        "GOOGLEPAY_logo");
    expect(deserializedPaymentProduct.fields.length, 2);
    expect(
        deserializedPaymentProduct.fields[0].dataRestrictions.isRequired, true);
    expect(
        deserializedPaymentProduct
            .fields[0].dataRestrictions.validationRules.length,
        0);
    expect(
        deserializedPaymentProduct.fields[0].displayHints?.alwaysShow, false);
    expect(deserializedPaymentProduct.fields[0].displayHints?.displayOrder, 0);
    expect(deserializedPaymentProduct.fields[0].displayHints?.formElement?.type,
        FormElementType.text);
    expect(deserializedPaymentProduct.fields[0].displayHints?.label, "");
    expect(deserializedPaymentProduct.fields[0].displayHints?.mask, isNull);
    expect(deserializedPaymentProduct.fields[0].displayHints?.obfuscate, false);
    expect(deserializedPaymentProduct.fields[0].displayHints?.placeholderLabel,
        "");
    expect(
        deserializedPaymentProduct.fields[0].displayHints?.preferredInputType,
        PreferredInputType.stringKeyboard);
    expect(
        deserializedPaymentProduct.fields[0].displayHints?.tooltip?.label, "");
    expect(deserializedPaymentProduct.fields[0].id, "encryptedPaymentData");
    expect(deserializedPaymentProduct.fields[0].type,
        PaymentProductFieldType.string);
    expect(deserializedPaymentProduct.id, "320");
    expect(deserializedPaymentProduct.paymentMethod, "mobile");
    expect(deserializedPaymentProduct.paymentProductGroup, isNull);
    expect(deserializedPaymentProduct.usesRedirectionTo3rdParty, false);
    expect(
        deserializedPaymentProduct
            .paymentProduct320SpecificData?.networks.length,
        2);
    expect(
        deserializedPaymentProduct.paymentProduct320SpecificData?.networks[0],
        "VISA");
    expect(
        deserializedPaymentProduct.paymentProduct320SpecificData?.networks[1],
        "MASTERCARD");
    expect(deserializedPaymentProduct.paymentProduct320SpecificData?.gateway,
        "onlinepaymentsgateway");
    expect(deserializedPaymentProduct.paymentProduct302SpecificData, isNull);
  });

  test('deserializePaymentProductNetworks', () async {
    final PaymentProductNetworks deserializedPaymentProductNetworks =
        PaymentProductNetworks.fromJson(await jsonMap(
            "test/mock_responses/payment_product_networks_response.json"));

    expect(deserializedPaymentProductNetworks.networks.length, 6);
    expect(deserializedPaymentProductNetworks.networks[0], "American Express");
    expect(deserializedPaymentProductNetworks.networks[5], "VISA");
  });

  test('deserializeSurchargeCalculationWithSurcharge', () async {
    final SurchargeCalculation deserializedSurchargeCalculation =
        SurchargeCalculation.fromJson(await jsonMap(
            "test/mock_responses/surcharge_calculation_response_with_surcharge.json"));

    expect(deserializedSurchargeCalculation.surcharges.length, 1);
    expect(deserializedSurchargeCalculation.surcharges[0].paymentProductId, 1);
    expect(deserializedSurchargeCalculation.surcharges[0].result,
        SurchargeResult.ok);
    expect(
        deserializedSurchargeCalculation.surcharges[0].netAmount.amount, 1000);
    expect(
        deserializedSurchargeCalculation.surcharges[0].netAmount.currencyCode,
        "USD");
    expect(
        deserializedSurchargeCalculation.surcharges[0].surchargeAmount.amount,
        366);
    expect(
        deserializedSurchargeCalculation
            .surcharges[0].surchargeAmount.currencyCode,
        "USD");
    expect(deserializedSurchargeCalculation.surcharges[0].totalAmount.amount,
        1366);
    expect(
        deserializedSurchargeCalculation.surcharges[0].totalAmount.currencyCode,
        "USD");
    expect(
        deserializedSurchargeCalculation
            .surcharges[0].surchargeRate?.surchargeProductTypeId,
        "PAYMENT_PRODUCT_TYPE_ID");
    expect(
        deserializedSurchargeCalculation
            .surcharges[0].surchargeRate?.surchargeProductTypeVersion,
        "1a2b3c-4d5e-6f7g8h-9i0j");
    expect(
        deserializedSurchargeCalculation
            .surcharges[0].surchargeRate?.adValoremRate,
        3.3);
    expect(
        deserializedSurchargeCalculation
            .surcharges[0].surchargeRate?.specificRate,
        333);
  });

  test('deserializeSurchargeCalculationWithoutSurcharge', () async {
    final SurchargeCalculation deserializedSurchargeCalculation =
        SurchargeCalculation.fromJson(await jsonMap(
            "test/mock_responses/surcharge_calculation_response_without_surcharge.json"));

    expect(deserializedSurchargeCalculation.surcharges.length, 1);
    expect(deserializedSurchargeCalculation.surcharges[0].paymentProductId, 2);
    expect(deserializedSurchargeCalculation.surcharges[0].result,
        SurchargeResult.noSurcharge);
    expect(
        deserializedSurchargeCalculation.surcharges[0].netAmount.amount, 1000);
    expect(
        deserializedSurchargeCalculation.surcharges[0].netAmount.currencyCode,
        "USD");
    expect(
        deserializedSurchargeCalculation.surcharges[0].surchargeAmount.amount,
        0);
    expect(
        deserializedSurchargeCalculation
            .surcharges[0].surchargeAmount.currencyCode,
        "USD");
    expect(deserializedSurchargeCalculation.surcharges[0].totalAmount.amount,
        1000);
    expect(
        deserializedSurchargeCalculation.surcharges[0].totalAmount.currencyCode,
        "USD");
    expect(
        deserializedSurchargeCalculation.surcharges[0].surchargeRate, isNull);
  });

  test('deserializePreparedPaymentRequest', () async {
    final PreparedPaymentRequest deserializedPreparedPaymentRequest =
        PreparedPaymentRequest.fromJson(
            await jsonMap("test/mock_responses/prepared_payment_request.json"));

    expect(deserializedPreparedPaymentRequest.encryptedFields,
        "A1B2C3encryptedFieldsD4E5F6");
    expect(deserializedPreparedPaymentRequest.encodedClientMetaInfo,
        "A1B2C3encodedClientMetaInfoD4E5F6");
  });

  test('deserializeCompleteApiErrorItem', () async {
    final ApiErrorItem deserializedApiErrorItem =
    ApiErrorItem.fromJson(
        await jsonMap("test/mock_responses/apiErrorItemComplete.json"));

    expect(deserializedApiErrorItem.errorCode,
        "123456");
    expect(deserializedApiErrorItem.category,
        "PAYMENT_PLATFORM_ERROR");
    expect(deserializedApiErrorItem.code,
        "123456");
    expect(deserializedApiErrorItem.httpStatusCode,
        404);
    expect(deserializedApiErrorItem.id,
        "1");
    expect(deserializedApiErrorItem.message,
        "The product could not be found");
    expect(deserializedApiErrorItem.retriable,
        false);
  });

  test('deserializeMissingOptionalPropertiesApiErrorItem', () async {
    final ApiErrorItem deserializedApiErrorItem =
    ApiErrorItem.fromJson(
        await jsonMap("test/mock_responses/apiErrorItemMissingOptionalProperties.json"));

    expect(deserializedApiErrorItem.errorCode,
        "123456");
    expect(deserializedApiErrorItem.category,
        null);
    expect(deserializedApiErrorItem.code,
        "This error does not contain a code");
    expect(deserializedApiErrorItem.httpStatusCode,
        null);
    expect(deserializedApiErrorItem.id,
        null);
    expect(deserializedApiErrorItem.message,
        "This error does not contain a message");
    expect(deserializedApiErrorItem.retriable,
        true);
  });
}
