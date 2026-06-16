/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2026 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */

import '../domain/card/card_source.dart';
import '../domain/amount_of_money.dart';
import '../domain/configuration/sdk_configuration.dart';
import '../domain/configuration/session_data.dart';
import '../domain/currency_conversion/currency_conversion_response.dart';
import '../domain/iin/iin_details_response.dart';
import '../domain/payment_context.dart';
import '../domain/payment_product/basic_payment_products.dart';
import '../domain/payment_product/payment_product.dart';
import '../domain/payment_product/payment_product_networks.dart';
import '../domain/payment_request/credit_card_token_request.dart';
import '../domain/payment_request/encrypted_request.dart';
import '../domain/payment_request/payment_request.dart';
import '../domain/public_key/public_key_response.dart';
import '../domain/surcharge_calculation/surcharge_calculation_response.dart';
import '../infrastructure/factories/default_service_factory.dart';
import '../infrastructure/interfaces/service_factory.dart';
import '../services/interfaces/client_service.dart';
import '../services/interfaces/encryption_service.dart';
import '../services/interfaces/payment_product_service.dart';
import 'session_data_normalizer.dart';

/// The main entry point for the Worldline Online Payments SDK.
///
/// Create an instance with validated [SessionData] and call the available methods
/// to interact with the Online Payments API.
class OnlinePaymentSdk {
  final ServiceFactory _factory;
  final PaymentProductService _paymentProductService;
  final ClientService _clientService;
  final EncryptionService _encryptionService;

  factory OnlinePaymentSdk(
    SessionData sessionData, {
    SdkConfiguration? configuration,
    ServiceFactory? factory,
  }) {
    final normalizedData = normalizeSessionData(sessionData);
    final resolvedFactory = factory ?? DefaultServiceFactory(normalizedData, configuration: configuration);
    return OnlinePaymentSdk._internal(resolvedFactory);
  }

  OnlinePaymentSdk._internal(ServiceFactory factory)
      : _factory = factory,
        _paymentProductService = factory.getPaymentProductService(),
        _clientService = factory.getClientService(),
        _encryptionService = factory.getEncryptionService();

  Future<BasicPaymentProducts> getBasicPaymentProducts(PaymentContext context) {
    return _paymentProductService.getBasicPaymentProducts(context);
  }

  Future<PaymentProduct> getPaymentProduct(int paymentProductId, PaymentContext context) {
    return _paymentProductService.getPaymentProduct(paymentProductId, context);
  }

  Future<PaymentProductNetworksResponse> getPaymentProductNetworks(int paymentProductId, PaymentContext context) {
    return _paymentProductService.getPaymentProductNetworks(paymentProductId, context);
  }

  Future<SurchargeCalculationResponse> getSurchargeCalculation(AmountOfMoney amountOfMoney, CardSource cardSource) {
    return _clientService.getSurchargeCalculation(amountOfMoney, cardSource);
  }

  Future<CurrencyConversionResponse> getCurrencyConversionQuote(AmountOfMoney amountOfMoney, CardSource cardSource) {
    return _clientService.getCurrencyConversionQuote(amountOfMoney, cardSource);
  }

  Future<IinDetailsResponse> getIinDetails(String partialCreditCardNumber, PaymentContext context) {
    return _clientService.getIinDetails(partialCreditCardNumber, context);
  }

  Future<PublicKeyResponse> getPublicKey() {
    return _encryptionService.getPublicKey();
  }

  Future<EncryptedRequest> encryptPaymentRequest(PaymentRequest request) {
    return _encryptionService.encryptPaymentRequest(request);
  }

  Future<EncryptedRequest> encryptTokenRequest(CreditCardTokenRequest request) {
    return _encryptionService.encryptTokenRequest(request);
  }

  /// Releases resources held by this SDK instance, including the HTTP client.
  void dispose() => _factory.dispose();
}
