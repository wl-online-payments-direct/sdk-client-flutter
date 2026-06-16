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

import 'dart:convert';
import 'dart:io';

import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/account_on_file/account_on_file_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/payment_product/basic_payment_product_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/api_models/payment_product/payment_product_dto.dart';
import 'package:online_payments_sdk/src/infrastructure/factories/default_payment_product_factory.dart';

Map<String, dynamic> loadFixture(String name) {
  final file = File('test/mock_responses/$name');
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

SdkResponse<Map<String, dynamic>> successResponse(Map<String, dynamic> data) {
  return SdkResponse(status: 200, success: true, data: data);
}

SdkResponse<Map<String, dynamic>> errorResponse(Map<String, dynamic> data, {int status = 400}) {
  return SdkResponse(status: status, success: false, data: data);
}

Map<String, dynamic> _clone(Map<String, dynamic> input) {
  return jsonDecode(jsonEncode(input)) as Map<String, dynamic>;
}

Map<String, dynamic> loadBasicPaymentProductsFixtureJson() {
  final json = _clone(loadFixture('basic_payment_products_response.json'));

  for (final product in (json['paymentProducts'] as List<dynamic>).cast<Map<String, dynamic>>()) {
    product['id'] = int.parse(product['id'] as String);
  }

  return json;
}

Map<String, dynamic> loadPaymentProductFixtureJson({bool cardholderNameRequired = true}) {
  final json = _clone(loadFixture('payment_product_response.json'));
  json['id'] = int.parse(json['id'] as String);

  for (final accountOnFile in (json['accountsOnFile'] as List<dynamic>).cast<Map<String, dynamic>>()) {
    accountOnFile['paymentProductId'] = int.parse(accountOnFile['paymentProductId'] as String);
  }

  final fields = (json['fields'] as List<dynamic>).cast<Map<String, dynamic>>();
  final cardholderNameField = fields.firstWhere((field) => field['id'] == 'cardholderName');
  (cardholderNameField['dataRestrictions'] as Map<String, dynamic>)['isRequired'] = cardholderNameRequired;

  return json;
}

PaymentProduct createTestPaymentProduct({bool cardholderNameRequired = true}) {
  return DefaultPaymentProductFactory().createPaymentProduct(
    PaymentProductDto.fromJson(loadPaymentProductFixtureJson(cardholderNameRequired: cardholderNameRequired)),
  );
}

AccountOnFile createTestAccountOnFile({
  String id = '1234',
  int paymentProductId = 3,
  String alias = '411111XXXXXX1111',
  String cardNumber = '9999-9999-9999-9999',
  bool includeCvv = true,
  AccountOnFileAttributeStatus cvvStatus = AccountOnFileAttributeStatus.mustWrite,
  String cvv = '',
  AccountOnFileAttributeStatus? cardholderNameStatus,
  String cardholderName = 'Wile E. Coyote',
  AccountOnFileAttributeStatus? expiryDateStatus,
  String expiryDate = '1226',
}) {
  final attributes = <Map<String, dynamic>>[
    {'key': 'alias', 'value': alias, 'status': 'READ_ONLY'},
    {'key': 'cardNumber', 'value': cardNumber, 'status': 'READ_ONLY'},
  ];

  if (includeCvv) {
    attributes.add({'key': 'cvv', 'value': cvv, 'status': _statusToDtoValue(cvvStatus)});
  }

  if (cardholderNameStatus != null) {
    attributes.add({
      'key': 'cardholderName',
      'value': cardholderName,
      'status': _statusToDtoValue(cardholderNameStatus),
    });
  }

  if (expiryDateStatus != null) {
    attributes.add({'key': 'expiryDate', 'value': expiryDate, 'status': _statusToDtoValue(expiryDateStatus)});
  }

  return DefaultPaymentProductFactory().createAccountOnFile(
    AccountOnFileDto.fromJson({
      'id': id,
      'paymentProductId': paymentProductId,
      'attributes': attributes,
      'displayHints': {
        'labelTemplate': [
          {'attributeKey': 'alias', 'mask': '{{9999}} {{9999}} {{9999}} {{9999}} {{999}}'},
        ],
        'logo': 'aof_logo',
      },
    }),
  );
}

BasicPaymentProduct createTestBasicPaymentProduct() {
  return DefaultPaymentProductFactory().createBasicPaymentProduct(
    BasicPaymentProductDto.fromJson({
      'id': 1,
      'paymentMethod': 'card',
      'paymentProductGroup': 'Cards',
      'allowsRecurring': true,
      'allowsTokenization': true,
      'usesRedirectionTo3rdParty': false,
      'displayHints': {'displayOrder': 1, 'label': 'Test label', 'logo': 'test-logo'},
      'accountsOnFile': [
        {
          'id': '1234',
          'paymentProductId': 1,
          'attributes': [
            {'key': 'alias', 'value': '411111XXXXXX1111', 'status': 'READ_ONLY'},
            {'key': 'cardNumber', 'value': '9999-9999-9999-9999', 'status': 'READ_ONLY'},
            {'key': 'cvv', 'value': '', 'status': 'MUST_WRITE'},
          ],
          'displayHints': {
            'labelTemplate': [
              {'attributeKey': 'alias', 'mask': '{{9999}} {{9999}} {{9999}} {{9999}} {{999}}'},
            ],
            'logo': 'aof_logo',
          },
        },
      ],
      'paymentProduct302SpecificData': {
        'networks': ['test network 1', 'test network 2', 'test network 3'],
      },
      'paymentProduct320SpecificData': {
        'networks': ['test network 1', 'test network 2', 'test network 3'],
        'gateway': 'test gateway',
      },
    }),
  );
}

PaymentProductField createTestCardNumberField({String? mask = '{{9999}} {{9999}} {{9999}} {{9999}} {{999}}'}) {
  return PaymentProductField(
    'cardNumber',
    PaymentProductFieldType.numericString,
    displayHints: ProductFieldDisplayHints(
      displayOrder: 0,
      label: 'Card number',
      mask: mask,
      obfuscate: true,
      placeholderLabel: 'test placeholder',
      preferredInputType: 'StringKeyboard',
      tooltipLabel: '',
      formElementType: 'text',
    ),
    dataRestrictions: DataRestrictions(
      isRequired: true,
      validationRules: [
        ValidationRuleLength(ValidationRuleType.length, 'length', 13, 19),
        ValidationRuleLuhn(ValidationRuleType.luhn, 'luhn'),
      ],
    ),
  );
}

String _statusToDtoValue(AccountOnFileAttributeStatus status) {
  switch (status) {
    case AccountOnFileAttributeStatus.readOnly:
      return 'READ_ONLY';
    case AccountOnFileAttributeStatus.canWrite:
      return 'CAN_WRITE';
    case AccountOnFileAttributeStatus.mustWrite:
      return 'MUST_WRITE';
  }
}
