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

import '../../helpers/test_utils.dart';

void main() {
  late PaymentProduct paymentProduct;
  late PaymentRequest paymentRequest;

  setUp(() {
    paymentProduct = createTestPaymentProduct(cardholderNameRequired: false);
    paymentRequest = PaymentRequest(paymentProduct: paymentProduct);
  });

  group('PaymentRequest', () {
    test('returns an existing field', () {
      final field = paymentRequest.getField('expiryDate');

      expect(field.getType(), PaymentProductFieldType.expiryDate);
      expect(field.getId(), 'expiryDate');
    });

    test('throws for an unknown field', () {
      expect(() => paymentRequest.getField('someField'), throwsA(isA<InvalidArgumentError>()));
    });

    test('returns all stored values in raw form', () {
      paymentRequest.getField('expiryDate').setValue('12/35');
      paymentRequest.getField('cvv').setValue('123');
      paymentRequest.getField('cardNumber').setValue('1234567890123456789');

      expect(paymentRequest.getValues(), {'expiryDate': '1235', 'cvv': '123', 'cardNumber': '1234567890123456789'});
      expect(paymentRequest.getValue('expiryDate'), '1235');
      expect(paymentRequest.getValue('cvv'), '123');
      expect(paymentRequest.getValue('cardNumber'), '1234567890123456789');
    });

    test('gets and sets values by field id', () {
      expect(paymentRequest.getValue('cvv'), isNull);

      paymentRequest.setValue('cvv', '123');

      expect(paymentRequest.getValue('cvv'), '123');
    });

    test('stores account on file and tokenize values', () {
      expect(paymentRequest.accountOnFile, isNull);
      expect(paymentRequest.tokenize, isFalse);

      paymentRequest.accountOnFile = createTestAccountOnFile(
        paymentProductId: 3,
        cvvStatus: AccountOnFileAttributeStatus.canWrite,
      );
      paymentRequest.tokenize = true;

      expect(paymentRequest.accountOnFile?.id, '1234');
      expect(paymentRequest.tokenize, isTrue);
    });

    test('treats read-only account-on-file fields as not writable', () {
      final request = PaymentRequest(
        paymentProduct: paymentProduct,
        accountOnFile: createTestAccountOnFile(paymentProductId: 3, cvvStatus: AccountOnFileAttributeStatus.canWrite),
      );

      expect(request.getValue('cardNumber'), isNull);
      expect(() => request.getField('cardNumber').setValue('2222222222'), throwsA(isA<InvalidArgumentError>()));
      expect(request.getField('cardNumber').getValue(), isNull);
    });

    test('returns three required-field errors without an account on file', () {
      final validationResult = paymentRequest.validate();

      expect(validationResult.isValid, isFalse);
      expect(validationResult.errorMessages, hasLength(3));
    });

    test('returns two required-field errors with an account on file', () {
      paymentRequest.accountOnFile = createTestAccountOnFile(paymentProductId: 3, includeCvv: false);

      final validationResult = paymentRequest.validate();

      expect(validationResult.isValid, isFalse);
      expect(validationResult.errorMessages, hasLength(2));
    });

    test('is valid when all required fields are set correctly', () {
      paymentRequest.setValue('cardNumber', '4242424242424242');
      paymentRequest.setValue('expiryDate', '12/26');
      paymentRequest.setValue('cvv', '123');

      final validationResult = paymentRequest.validate();

      expect(validationResult.isValid, isTrue);
      expect(validationResult.errorMessages, isEmpty);
    });

    test('returns one error when cvv is must-write and left empty', () {
      paymentRequest.accountOnFile = createTestAccountOnFile(
        paymentProductId: 3,
        cvvStatus: AccountOnFileAttributeStatus.mustWrite,
        expiryDateStatus: AccountOnFileAttributeStatus.canWrite,
      );

      final validationResult = paymentRequest.validate();

      expect(validationResult.isValid, isFalse);
      expect(validationResult.errorMessages, hasLength(1));
      expect(validationResult.errorMessages.single.paymentProductFieldId, 'cvv');
    });

    test('returns one error when cvv is must-write and invalid', () {
      paymentRequest.accountOnFile = createTestAccountOnFile(
        paymentProductId: 3,
        cvvStatus: AccountOnFileAttributeStatus.mustWrite,
        expiryDateStatus: AccountOnFileAttributeStatus.canWrite,
      );
      paymentRequest.setValue('cvv', '1');

      final validationResult = paymentRequest.validate();

      expect(validationResult.isValid, isFalse);
      expect(validationResult.errorMessages, hasLength(1));
    });

    test('passes when cvv is must-write and valid', () {
      paymentRequest.accountOnFile = createTestAccountOnFile(
        paymentProductId: 3,
        cvvStatus: AccountOnFileAttributeStatus.mustWrite,
        expiryDateStatus: AccountOnFileAttributeStatus.canWrite,
      );
      paymentRequest.setValue('cvv', '123');

      final validationResult = paymentRequest.validate();

      expect(validationResult.isValid, isTrue);
      expect(validationResult.errorMessages, isEmpty);
    });

    test('does not validate optional can-write cardholderName when it is omitted', () {
      paymentRequest.accountOnFile = createTestAccountOnFile(
        paymentProductId: 3,
        cvvStatus: AccountOnFileAttributeStatus.canWrite,
        expiryDateStatus: AccountOnFileAttributeStatus.canWrite,
        cardholderNameStatus: AccountOnFileAttributeStatus.canWrite,
      );
      paymentRequest.setValue('cvv', '123');
      paymentRequest.setValue('expiryDate', '11/26');

      final validationResult = paymentRequest.validate();

      expect(validationResult.isValid, isTrue);
      expect(validationResult.errorMessages, isEmpty);
    });

    test('validates optional can-write cardholderName when a value is provided', () {
      paymentRequest.accountOnFile = createTestAccountOnFile(
        paymentProductId: 3,
        cvvStatus: AccountOnFileAttributeStatus.canWrite,
        expiryDateStatus: AccountOnFileAttributeStatus.canWrite,
        cardholderNameStatus: AccountOnFileAttributeStatus.canWrite,
      );
      paymentRequest.setValue('cvv', '123');
      paymentRequest.setValue('expiryDate', '11/26');
      paymentRequest.setValue('cardholderName', 'x');

      final validationResult = paymentRequest.validate();

      expect(validationResult.isValid, isFalse);
      expect(validationResult.errorMessages, hasLength(1));
      expect(validationResult.errorMessages.single.paymentProductFieldId, 'cardholderName');
    });
  });
}
