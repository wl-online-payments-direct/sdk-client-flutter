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

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/infrastructure/utils/supported_products_util.dart';

import 'test_credentials.dart';
import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await TestCredentials.get();
  });

  group('sdk.getPaymentProduct', () {
    late OnlinePaymentSdk sdk;

    setUp(() => sdk = TestHelpers.createSdk());
    tearDown(() => sdk.dispose());

    test('getPaymentProduct_WhenProductDoesNotExist_ThrowsSdkError', () async {
      await expectLater(
            () => sdk.getPaymentProduct(99999, TestHelpers.createTestPaymentContext()),
        throwsA(isA<SdkError>()),
      );
    });

    test('getPaymentProduct_ReturnsProductWithValidFieldStructure', () async {
      final product = await sdk.getPaymentProduct(1, TestHelpers.createTestPaymentContext());

      expect(product.fields, isA<List<PaymentProductField>>());

      if (product.fields.isNotEmpty) {
        final first = product.fields.first;

        expect(first.id, isA<String>());
        expect(first.type, isA<PaymentProductFieldType>());
        expect(first.displayHints, isA<ProductFieldDisplayHints?>());
        expect(first.dataRestrictions, isA<DataRestrictions>());
      }
    });

    test('getPaymentProduct_ReturnsProductWithDisplayHints', () async {
      final product = await sdk.getPaymentProduct(1, TestHelpers.createTestPaymentContext());

      expect(product.label, isNotNull);
      expect(product.logo, isNotNull);
      expect(product.logo, isNotEmpty);
      expect(product.displayOrder, isA<int?>());
    });

    test('getPaymentProduct_ReturnsProductWithPaymentProductFields', () async {
      final product = await sdk.getPaymentProduct(1, TestHelpers.createTestPaymentContext());

      expect(product.fields, isNotEmpty);
      expect(product.fields.any((field) => field.id == 'cardNumber'), isTrue);
    });

    test('getPaymentProduct_CalledTwice_ReturnsCachedResultOnSecondCall', () async {
      final (countingSdk, counter) = createSdkWithCounter();
      addTearDown(countingSdk.dispose);

      await countingSdk.getPaymentProduct(1, TestHelpers.createTestPaymentContext());
      await countingSdk.getPaymentProduct(1, TestHelpers.createTestPaymentContext());

      expect(counter.callCount, equals(1));
    });

    test('getPaymentProduct_WithDifferentContext_MakesNewApiCall', () async {
      final (countingSdk, counter) = createSdkWithCounter();
      addTearDown(countingSdk.dispose);

      await countingSdk.getPaymentProduct(
        1,
        TestHelpers.createTestPaymentContext(amountInCents: 1000),
      );

      await countingSdk.getPaymentProduct(
        1,
        TestHelpers.createTestPaymentContext(amountInCents: 2000),
      );

      expect(counter.callCount, equals(2));
    });

    test('getPaymentProduct_WhenUnsupportedSdkProductId_ThrowsResponseErrorWith404', () async {
      for (final id in SupportedProductsUtil.sdkUnsupportedProducts) {
        try {
          await sdk.getPaymentProduct(id, TestHelpers.createTestPaymentContext());
          fail('Should have thrown for product id $id');
        } catch (error) {
          expect(error, isA<ResponseError>(), reason: 'Expected ResponseError for id $id');

          final responseError = error as ResponseError;

          expect(responseError.statusCode, equals(404));
          expect(responseError.apiError?.errors?.first.errorCode, equals('1007'));
          expect(responseError.apiError?.errors?.first.propertyName, equals('productId'));
        }
      }
    });

    test('getPaymentProduct_ReturnsProductWithMappedAccountsOnFile', () async {
      final product = await sdk.getPaymentProduct(1, TestHelpers.createTestPaymentContext());

      expect(product.accountsOnFile, isA<List<AccountOnFile>>());
    });
  });

  group('sdk.getPaymentProduct deterministic HTTP scenarios', () {
    test('getPaymentProduct_MapsProductDisplayHints', () async {
      final client = StubHttpClient((request) async {
        expect(request.url.path, contains('/products/1'));

        return jsonResponse(
          200,
          _paymentProductResponse(
            displayHints: {
              'displayOrder': 10,
              'label': 'Visa',
              'logo': 'visa.png',
            },
          ),
        );
      });

      final sdk = createSdkWithHttpClient(client);
      addTearDown(sdk.dispose);

      final product = await sdk.getPaymentProduct(1, TestHelpers.createTestPaymentContext());

      expect(product.id, equals(1));
      expect(product.paymentMethod, equals('card'));
      expect(product.label, equals('Visa'));
      expect(product.logo, equals('visa.png'));
      expect(product.displayOrder, equals(10));
    });

    test('getPaymentProduct_MapsPaymentProductFieldsWithDisplayHints', () async {
      final client = StubHttpClient((request) async {
        return jsonResponse(
          200,
          _paymentProductResponse(
            fields: [
              _paymentProductFieldJson(
                id: 'cvv',
                type: 'numericstring',
                isRequired: true,
                displayOrder: 2,
                label: 'Security code',
                placeholderLabel: '123',
                mask: '{{999}}',
                preferredInputType: 'IntegerKeyboard',
                formElementType: 'text',
                tooltipLabel: 'The 3 digit security code on the back of your card.',
              ),
              _paymentProductFieldJson(
                id: 'cardNumber',
                type: 'numericstring',
                isRequired: true,
                displayOrder: 1,
                label: 'Card number',
                placeholderLabel: '1234 5678 9012 3456',
                mask: '{{9999}} {{9999}} {{9999}} {{9999}}',
                preferredInputType: 'IntegerKeyboard',
                formElementType: 'text',
              ),
            ],
          ),
        );
      });

      final sdk = createSdkWithHttpClient(client);
      addTearDown(sdk.dispose);

      final product = await sdk.getPaymentProduct(1, TestHelpers.createTestPaymentContext());

      expect(product.fields, hasLength(2));

      final cardNumberField = product.getField('cardNumber');
      expect(cardNumberField, isNotNull);
      expect(cardNumberField?.type, equals(PaymentProductFieldType.numericString));
      expect(cardNumberField?.isRequired(), isTrue);
      expect(cardNumberField?.displayHints?.displayOrder, equals(1));
      expect(cardNumberField?.displayHints?.label, equals('Card number'));
      expect(cardNumberField?.displayHints?.placeholderLabel, equals('1234 5678 9012 3456'));
      expect(cardNumberField?.displayHints?.mask, equals('{{9999}} {{9999}} {{9999}} {{9999}}'));
      expect(cardNumberField?.displayHints?.preferredInputType, equals('IntegerKeyboard'));
      expect(cardNumberField?.displayHints?.formElementType, equals('text'));

      final cvvField = product.getField('cvv');
      expect(cvvField, isNotNull);
      expect(cvvField?.type, equals(PaymentProductFieldType.numericString));
      expect(cvvField?.isRequired(), isTrue);
      expect(cvvField?.displayHints?.displayOrder, equals(2));
      expect(cvvField?.displayHints?.label, equals('Security code'));
      expect(cvvField?.displayHints?.placeholderLabel, equals('123'));
      expect(cvvField?.displayHints?.mask, equals('{{999}}'));
      expect(cvvField?.displayHints?.tooltipLabel, equals('The 3 digit security code on the back of your card.'));
    });

    test('getPaymentProduct_MapsAccountsOnFile', () async {
      final client = StubHttpClient((request) async {
        return jsonResponse(
          200,
          _paymentProductResponse(
            accountsOnFile: [
              {
                'id': '12345',
                'paymentProductId': 1,
                'attributes': [
                  {
                    'key': 'alias',
                    'value': '433026******1112',
                    'status': 'READ_ONLY',
                  },
                  {
                    'key': 'expiryDate',
                    'value': '1228',
                    'status': 'READ_ONLY',
                  },
                  {
                    'key': 'cvv',
                    'value': '',
                    'status': 'MUST_WRITE',
                  },
                ],
                'displayHints': {
                  'logo': 'visa.png',
                  'labelTemplate': [
                    {
                      'attributeKey': 'alias',
                      'mask': '{{999999******9999}}',
                    },
                  ],
                },
              },
            ],
          ),
        );
      });

      final sdk = createSdkWithHttpClient(client);
      addTearDown(sdk.dispose);

      final product = await sdk.getPaymentProduct(1, TestHelpers.createTestPaymentContext());

      expect(product.accountsOnFile, hasLength(1));

      final accountOnFile = product.accountsOnFile.first;

      expect(accountOnFile.id, equals('12345'));
      expect(accountOnFile.paymentProductId, equals(1));
      expect(accountOnFile.getValue('alias'), equals('433026******1112'));
      expect(accountOnFile.getValue('expiryDate'), equals('1228'));
      expect(accountOnFile.getValue('cvv'), equals(''));
      expect(accountOnFile.getAttribute('alias')?.status, equals(AccountOnFileAttributeStatus.readOnly));
      expect(accountOnFile.getAttribute('expiryDate')?.status, equals(AccountOnFileAttributeStatus.readOnly));
      expect(accountOnFile.getAttribute('cvv')?.status, equals(AccountOnFileAttributeStatus.mustWrite));
      expect(accountOnFile.getRequiredAttributes().map((attribute) => attribute.key), contains('cvv'));
      expect(accountOnFile.getReadOnlyAttributes().map((attribute) => attribute.key), containsAll(['alias', 'expiryDate']));
      expect(accountOnFile.isWritable('alias'), isFalse);
      expect(accountOnFile.isWritable('cvv'), isTrue);
    });
  });
}

Map<String, dynamic> _paymentProductResponse({
  Map<String, dynamic>? displayHints,
  List<Map<String, dynamic>>? fields,
  List<Map<String, dynamic>>? accountsOnFile,
}) {
  return {
    'id': 1,
    'paymentMethod': 'card',
    'paymentProductGroup': 'cards',
    'allowsRecurring': true,
    'allowsTokenization': true,
    'usesRedirectionTo3rdParty': false,
    'displayHints': displayHints ??
        {
          'displayOrder': 0,
          'label': 'Visa',
          'logo': 'visa.png',
        },
    'fields': fields ?? [],
    'accountsOnFile': accountsOnFile ?? [],
  };
}

Map<String, dynamic> _paymentProductFieldJson({
  required String id,
  required String type,
  required bool isRequired,
  required int displayOrder,
  required String label,
  String? placeholderLabel,
  String? mask,
  String? preferredInputType,
  String? formElementType,
  String? tooltipLabel,
}) {
  return {
    'id': id,
    'type': type,
    'dataRestrictions': {
      'isRequired': isRequired,
      'validators': {},
    },
    'displayHints': {
      'displayOrder': displayOrder,
      'label': label,
      if (placeholderLabel != null) 'placeholderLabel': placeholderLabel,
      if (mask != null) 'mask': mask,
      if (preferredInputType != null) 'preferredInputType': preferredInputType,
      if (formElementType != null)
        'formElement': {
          'type': formElementType,
        },
      if (tooltipLabel != null)
        'tooltip': {
          'label': tooltipLabel,
        },
    },
  };
}