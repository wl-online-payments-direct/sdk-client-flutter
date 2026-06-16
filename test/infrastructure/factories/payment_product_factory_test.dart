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
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/payment_product/basic_payment_product_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/payment_product/basic_payment_products_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/payment_product/data_restrictions_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/payment_product/payment_product_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/payment_product/payment_product_field_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/factories/default_payment_product_factory.dart';

import '../../helpers/test_utils.dart';

void main() {
  group('DefaultPaymentProductFactory', () {
    final factory = DefaultPaymentProductFactory();

    test('creates a BasicPaymentProduct from fixture data', () {
      final productsJson = loadBasicPaymentProductsFixtureJson();
      final firstProductJson = (productsJson['paymentProducts'] as List<dynamic>).first as Map<String, dynamic>;
      final product = factory.createBasicPaymentProduct(BasicPaymentProductDto.fromJson(firstProductJson));

      expect(product, isA<BasicPaymentProduct>());
      expect(product.id, 2);
    });

    test('creates BasicPaymentProducts from fixture data', () {
      final dto = BasicPaymentProductsDto.fromJson(loadBasicPaymentProductsFixtureJson());
      final products = factory.createBasicPaymentProducts(dto);

      expect(products.basicPaymentProducts, hasLength(3));
      expect(products.basicPaymentProducts.first, isA<BasicPaymentProduct>());
    });

    test('creates a PaymentProduct from fixture data', () {
      final product = factory.createPaymentProduct(
        PaymentProductDto.fromJson(loadPaymentProductFixtureJson()),
      );

      expect(product, isA<PaymentProduct>());
      expect(product.id, 3);
      expect(product.fields, hasLength(4));
    });

    test('createPaymentProduct_WhenDtoContainsFields_SortsFieldsByDisplayOrder', () {
      final json = loadPaymentProductFixtureJson();
      (json['fields'] as List<dynamic>).clear();
      (json['fields'] as List<dynamic>).addAll([
        {
          'id': 'field-c',
          'type': 'string',
          'dataRestrictions': {'isRequired': false, 'validators': {}},
          'displayHints': {'displayOrder': 3, 'label': 'C', 'obfuscate': false, 'alwaysShow': false},
        },
        {
          'id': 'field-a',
          'type': 'string',
          'dataRestrictions': {'isRequired': false, 'validators': {}},
          'displayHints': {'displayOrder': 1, 'label': 'A', 'obfuscate': false, 'alwaysShow': false},
        },
        {
          'id': 'field-b',
          'type': 'string',
          'dataRestrictions': {'isRequired': false, 'validators': {}},
          'displayHints': {'displayOrder': 2, 'label': 'B', 'obfuscate': false, 'alwaysShow': false},
        },
      ]);

      final product = factory.createPaymentProduct(PaymentProductDto.fromJson(json));

      expect(product.fields.map((field) => field.id).toList(), equals(['field-a', 'field-b', 'field-c']));
    });

    test('createBasicPaymentProduct_WhenDtoContainsSpecificData_Maps320SpecificProductData', () {
      final productsJson = loadBasicPaymentProductsFixtureJson();
      final firstJson = (productsJson['paymentProducts'] as List<dynamic>).first as Map<String, dynamic>;
      firstJson['paymentProduct320SpecificData'] = {
        'networks': ['Visa', 'Mastercard'],
        'gateway': 'test-gateway',
      };

      final product = factory.createBasicPaymentProduct(BasicPaymentProductDto.fromJson(firstJson));

      expect(product.paymentProduct320SpecificData, isNotNull);
      expect(product.paymentProduct320SpecificData!.networks, equals(['Visa', 'Mastercard']));
      expect(product.paymentProduct320SpecificData!.gateway, equals('test-gateway'));
    });

    test('createDataRestrictions_WhenIsRequiredIsMissing_DefaultsToFalse', () {
      final fieldDto = PaymentProductFieldDto(
        id: 'test-field',
        type: 'string',
        dataRestrictions: const DataRestrictionsDto(),
      );

      final field = factory.createPaymentProductField(fieldDto);

      expect(field.dataRestrictions.isRequired, isFalse);
    });

    test('createDisplayHintsForField_WhenDtoIsUndefined_UsesDefaultValues', () {
      final fieldDto = PaymentProductFieldDto(
        id: 'test-field',
        type: 'string',
        dataRestrictions: const DataRestrictionsDto(isRequired: false),
      );

      final field = factory.createPaymentProductField(fieldDto);

      expect(field.displayHints, isNotNull);
      expect(field.displayHints?.displayOrder, equals(0));
    });
  });
}
