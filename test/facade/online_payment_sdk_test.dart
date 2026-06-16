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

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/services/interfaces/client_service.dart';
import 'package:online_payments_sdk/src/services/interfaces/encryption_service.dart';
import 'package:online_payments_sdk/src/services/interfaces/payment_product_service.dart';

// --- Test doubles ---

class _FakeEncryptionService implements EncryptionService {
  PublicKeyResponse? publicKeyResult;
  EncryptedRequest? encryptResult;
  Object? throwError;

  @override
  Future<PublicKeyResponse> getPublicKey() async {
    if (throwError != null) throw throwError!;
    return publicKeyResult!;
  }

  @override
  Future<EncryptedRequest> encryptPaymentRequest(PaymentRequest request) async {
    if (throwError != null) throw throwError!;
    return encryptResult!;
  }

  @override
  Future<EncryptedRequest> encryptTokenRequest(CreditCardTokenRequest request) async {
    if (throwError != null) throw throwError!;
    return encryptResult!;
  }
}

class _FakePaymentProductService implements PaymentProductService {
  BasicPaymentProducts? productsResult;
  PaymentProduct? productResult;
  PaymentProductNetworksResponse? networksResult;
  Object? throwError;

  @override
  Future<BasicPaymentProducts> getBasicPaymentProducts(PaymentContext context) async {
    if (throwError != null) throw throwError!;
    return productsResult!;
  }

  @override
  Future<PaymentProduct> getPaymentProduct(int paymentProductId, PaymentContext context) async {
    if (throwError != null) throw throwError!;
    return productResult!;
  }

  @override
  Future<PaymentProductNetworksResponse> getPaymentProductNetworks(
    int paymentProductId,
    PaymentContext context,
  ) async {
    if (throwError != null) throw throwError!;
    return networksResult!;
  }
}

class _FakeClientService implements ClientService {
  IinDetailsResponse? iinResult;
  SurchargeCalculationResponse? surchargeResult;
  CurrencyConversionResponse? currencyResult;
  Object? throwError;

  @override
  Future<IinDetailsResponse> getIinDetails(String partialCreditCardNumber, PaymentContext context) async {
    if (throwError != null) throw throwError!;
    return iinResult!;
  }

  @override
  Future<SurchargeCalculationResponse> getSurchargeCalculation(
    AmountOfMoney amountOfMoney,
    CardSource cardSource,
  ) async {
    if (throwError != null) throw throwError!;
    return surchargeResult!;
  }

  @override
  Future<CurrencyConversionResponse> getCurrencyConversionQuote(
    AmountOfMoney amountOfMoney,
    CardSource cardSource,
  ) async {
    if (throwError != null) throw throwError!;
    return currencyResult!;
  }
}

class _FakeServiceFactory implements ServiceFactory {
  final _FakeEncryptionService encryptionService;
  final _FakePaymentProductService paymentProductService;
  final _FakeClientService clientService;

  _FakeServiceFactory({
    required this.encryptionService,
    required this.paymentProductService,
    required this.clientService,
  });

  @override
  EncryptionService getEncryptionService() => encryptionService;

  @override
  PaymentProductService getPaymentProductService() => paymentProductService;

  @override
  ClientService getClientService() => clientService;

  @override
  void dispose() {}
}

// --- Fixtures ---

class _CapturingHttpClient extends http.BaseClient {
  final List<Uri> capturedUris = [];

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    capturedUris.add(request.url);
    return http.StreamedResponse(const Stream.empty(), 200);
  }
}

final _sessionData = SessionData(
  clientSessionId: 'test-session-id',
  customerId: 'test-customer-id',
  clientApiUrl: 'https://api.example.com/client/',
  assetUrl: 'https://assets.example.com',
);

final _paymentContext = PaymentContext(AmountOfMoney(1000, 'EUR'), 'NL');

void main() {
  late _FakeEncryptionService fakeEncryptionService;
  late _FakePaymentProductService fakePaymentProductService;
  late _FakeClientService fakeClientService;
  late _FakeServiceFactory fakeFactory;
  late OnlinePaymentSdk sdk;

  setUp(() {
    fakeEncryptionService = _FakeEncryptionService();
    fakePaymentProductService = _FakePaymentProductService();
    fakeClientService = _FakeClientService();
    fakeFactory = _FakeServiceFactory(
      encryptionService: fakeEncryptionService,
      paymentProductService: fakePaymentProductService,
      clientService: fakeClientService,
    );
    sdk = OnlinePaymentSdk(_sessionData, factory: fakeFactory);
  });

  test('should create instance with session data', () {
    expect(OnlinePaymentSdk(_sessionData), isA<OnlinePaymentSdk>());
  });

  test('should create instance with session data and configuration', () {
    final config = SdkConfiguration(appIdentifier: 'TestApp');
    expect(OnlinePaymentSdk(_sessionData, configuration: config), isA<OnlinePaymentSdk>());
  });

  test('creates services using DefaultServiceFactory when no factory is provided', () {
    final sdk = OnlinePaymentSdk(_sessionData);
    expect(sdk, isA<OnlinePaymentSdk>());
    expect(() => sdk.dispose(), returnsNormally);
  });

  test('normalizes session data before creating the default factory', () async {
    final sessionDataWithTrailingSlash = SessionData(
      clientSessionId: _sessionData.clientSessionId,
      customerId: _sessionData.customerId,
      clientApiUrl: 'https://api.example.com/client/',
      assetUrl: _sessionData.assetUrl,
    );
    final capturingClient = _CapturingHttpClient();
    final sdk = OnlinePaymentSdk(
      sessionDataWithTrailingSlash,
      factory: DefaultServiceFactory(sessionDataWithTrailingSlash, httpClient: capturingClient),
    );
    // Trigger a real request so the normalized URL is used
    try {
      await sdk.getPublicKey();
    } catch (_) {
      // Network will fail (no real server) — we only care about the captured URL
    }
    sdk.dispose();

    expect(capturingClient.capturedUris, isNotEmpty);
    // The trailing slash must have been stripped from the base URL
    final capturedUrl = capturingClient.capturedUris.first.toString();
    expect(capturedUrl, isNot(contains('client//')));
    expect(capturedUrl, contains('https://api.example.com/client/'));
  });

  group('getBasicPaymentProducts', () {
    test('delegates to payment product service', () async {
      final expected = BasicPaymentProducts([]);
      fakePaymentProductService.productsResult = expected;

      final result = await sdk.getBasicPaymentProducts(_paymentContext);

      expect(result, same(expected));
    });

    test('propagates rejection from payment product service', () async {
      final error = Exception('service error');
      fakePaymentProductService.throwError = error;

      await expectLater(sdk.getBasicPaymentProducts(_paymentContext), throwsA(same(error)));
    });
  });

  group('getPaymentProduct', () {
    test('delegates to payment product service and returns result', () async {
      final expected = _dummyProduct();
      fakePaymentProductService.productResult = expected;

      final result = await sdk.getPaymentProduct(1, _paymentContext);

      expect(result, same(expected));
    });

    test('propagates rejection from payment product service', () async {
      final error = Exception('service error');
      fakePaymentProductService.throwError = error;

      await expectLater(sdk.getPaymentProduct(1, _paymentContext), throwsA(same(error)));
    });
  });

  group('getPaymentProductNetworks', () {
    test('delegates to payment product service', () async {
      final expected = PaymentProductNetworksResponse(const ['Visa', 'Mastercard']);
      fakePaymentProductService.networksResult = expected;

      final result = await sdk.getPaymentProductNetworks(1, _paymentContext);

      expect(result, same(expected));
    });

    test('propagates rejection from payment product service', () async {
      final error = Exception('service error');
      fakePaymentProductService.throwError = error;

      await expectLater(sdk.getPaymentProductNetworks(1, _paymentContext), throwsA(same(error)));
    });
  });

  group('getSurchargeCalculation', () {
    test('delegates to client service', () async {
      final expected = SurchargeCalculationResponse(const []);
      fakeClientService.surchargeResult = expected;

      final result = await sdk.getSurchargeCalculation(
        AmountOfMoney(1000, 'EUR'),
        CardSourceWithCard(Card('424242')),
      );

      expect(result, same(expected));
    });

    test('propagates rejection from client service', () async {
      final error = Exception('service error');
      fakeClientService.throwError = error;

      await expectLater(
        sdk.getSurchargeCalculation(AmountOfMoney(1000, 'EUR'), CardSourceWithCard(Card('424242'))),
        throwsA(same(error)),
      );
    });
  });

  group('getCurrencyConversionQuote', () {
    test('delegates to client service', () async {
      final expected = _dummyCurrencyConversionResponse();
      fakeClientService.currencyResult = expected;

      final result = await sdk.getCurrencyConversionQuote(
        AmountOfMoney(1000, 'EUR'),
        CardSourceWithCard(Card('424242')),
      );

      expect(result, same(expected));
    });

    test('propagates rejection from client service', () async {
      final error = Exception('service error');
      fakeClientService.throwError = error;

      await expectLater(
        sdk.getCurrencyConversionQuote(AmountOfMoney(1000, 'EUR'), CardSourceWithCard(Card('424242'))),
        throwsA(same(error)),
      );
    });
  });

  group('getIinDetails', () {
    test('delegates to client service', () async {
      final expected = IinDetailsResponse(IinStatus.supported, countryCode: 'NL', paymentProductId: 1);
      fakeClientService.iinResult = expected;

      final result = await sdk.getIinDetails('424242', _paymentContext);

      expect(result, same(expected));
    });

    test('propagates rejection from client service', () async {
      final error = Exception('service error');
      fakeClientService.throwError = error;

      await expectLater(sdk.getIinDetails('424242', _paymentContext), throwsA(same(error)));
    });
  });

  group('getPublicKey', () {
    test('delegates to encryption service', () async {
      final expected = PublicKeyResponse('kid', 'pk');
      fakeEncryptionService.publicKeyResult = expected;

      final result = await sdk.getPublicKey();

      expect(result, same(expected));
    });

    test('propagates rejection from encryption service', () async {
      final error = Exception('service error');
      fakeEncryptionService.throwError = error;

      await expectLater(sdk.getPublicKey(), throwsA(same(error)));
    });
  });

  group('encryptPaymentRequest', () {
    test('delegates to encryption service', () async {
      final expected = EncryptedRequest('encrypted', encodedClientMetaInfo: 'meta');
      fakeEncryptionService.encryptResult = expected;

      final request = PaymentRequest(paymentProduct: _dummyProduct());
      final result = await sdk.encryptPaymentRequest(request);

      expect(result, same(expected));
    });

    test('propagates rejection from encryption service', () async {
      final error = Exception('service error');
      fakeEncryptionService.throwError = error;

      await expectLater(
        sdk.encryptPaymentRequest(PaymentRequest(paymentProduct: _dummyProduct())),
        throwsA(same(error)),
      );
    });
  });

  group('encryptTokenRequest', () {
    test('delegates to encryption service', () async {
      final expected = EncryptedRequest('encrypted', encodedClientMetaInfo: 'meta');
      fakeEncryptionService.encryptResult = expected;

      final result = await sdk.encryptTokenRequest(CreditCardTokenRequest());

      expect(result, same(expected));
    });

    test('propagates rejection from encryption service', () async {
      final error = Exception('service error');
      fakeEncryptionService.throwError = error;

      await expectLater(sdk.encryptTokenRequest(CreditCardTokenRequest()), throwsA(same(error)));
    });
  });
}

PaymentProduct _dummyProduct() {
  return PaymentProduct(1, 'card');
}

CurrencyConversionResponse _dummyCurrencyConversionResponse() {
  return CurrencyConversionResponse(
    'doc-session-id',
    CurrencyConversionResult(ConversionResultType.allowed),
    DccProposal(
      AmountOfMoney(1000, 'EUR'),
      AmountOfMoney(1200, 'USD'),
      RateDetails(1.2, 0.833, 0.0, '2024-01-01T00:00:00', 'ECB'),
    ),
  );
}
