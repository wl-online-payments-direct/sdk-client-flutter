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
import 'package:online_payments_sdk/src/infrastructure/utils/formatter.dart';

const maskExpiryDate = '{{99}}-{{99}}';
const maskCardNumber = '{{9999}} {{9999}} {{9999}} {{9999}} {{999}}';

void main() {
  group('Formatter.applyMask', () {
    for (final entry in [('1', '1'), ('12', '12'), ('123', '12-3'), ('1234', '12-34'), ('12345', '12-34')]) {
      test('applies expiry date mask to ${entry.$1}', () {
        expect(Formatter.applyMask(maskExpiryDate, entry.$1), entry.$2);
      });
    }

    for (final entry in [
      ('1', '1'),
      ('12', '12'),
      ('123', '123'),
      ('1234', '1234'),
      ('12345', '1234 5'),
      ('123456', '1234 56'),
      ('1234567', '1234 567'),
      ('12345678', '1234 5678'),
      ('123456789', '1234 5678 9'),
      ('1234567890', '1234 5678 90'),
      ('12345678901', '1234 5678 901'),
      ('123456789012', '1234 5678 9012'),
      ('1234567890123', '1234 5678 9012 3'),
      ('12345678901234', '1234 5678 9012 34'),
      ('123456789012345', '1234 5678 9012 345'),
      ('1234567890123456', '1234 5678 9012 3456'),
      ('12345678901234567', '1234 5678 9012 3456 7'),
      ('123456789012345678', '1234 5678 9012 3456 78'),
      ('1234567890123456789', '1234 5678 9012 3456 789'),
      ('12345678901234567890', '1234 5678 9012 3456 789'),
      ('1234XX78901234567890', '1234 XX78 9012 3456 789'),
    ]) {
      test('applies card number mask to ${entry.$1}', () {
        expect(Formatter.applyMask(maskCardNumber, entry.$1), entry.$2);
      });
    }

    for (final entry in [('1', '1'), ('12', '12'), ('123', '123'), ('1234', '1234'), ('12345', '12345')]) {
      test('returns the original value when there is no mask for ${entry.$1}', () {
        expect(Formatter.applyMask(null, entry.$1), entry.$2);
      });
    }
  });

  group('Formatter.removeMask', () {
    for (final entry in [('1', '1'), ('12', '12'), ('12-3', '123'), ('12-34', '1234'), ('12-345', '1234')]) {
      test('removes expiry date mask from ${entry.$1}', () {
        expect(Formatter.removeMask(maskExpiryDate, entry.$1), entry.$2);
      });
    }

    for (final entry in [
      ('1', '1'),
      ('12', '12'),
      ('123', '123'),
      ('1234', '1234'),
      ('1234 5', '12345'),
      ('1234 56', '123456'),
      ('1234 567', '1234567'),
      ('1234 5678', '12345678'),
      ('1234 5678 9', '123456789'),
      ('1234 5678 90', '1234567890'),
      ('1234 5678 901', '12345678901'),
      ('1234 5678 9012', '123456789012'),
      ('1234 5678 9012 3', '1234567890123'),
      ('1234 5678 9012 34', '12345678901234'),
      ('1234 5678 9012 345', '123456789012345'),
      ('1234 5678 9012 3456', '1234567890123456'),
      ('1234 5678 9012 3456 7', '12345678901234567'),
      ('1234 5678 9012 3456 78', '123456789012345678'),
      ('1234 5678 9012 3456 789', '1234567890123456789'),
      ('1234 5678 9012 3456 7890', '1234567890123456789'),
    ]) {
      test('removes card number mask from ${entry.$1}', () {
        expect(Formatter.removeMask(maskCardNumber, entry.$1), entry.$2);
      });
    }

    for (final entry in [('1', '1'), ('12', '12'), ('12-3', '12-3'), ('12-34', '12-34'), ('12-345', '12-345')]) {
      test('returns the original value when there is no mask for ${entry.$1}', () {
        expect(Formatter.removeMask(null, entry.$1), entry.$2);
      });
    }
  });

  group('Formatter.getMaxLengthBasedOnMask', () {
    test('getMaxLengthBasedOnMask_WithMask_ReturnsCorrectMaxLength', () {
      expect(Formatter.getMaxLengthBasedOnMask(maskExpiryDate), equals(4));
    });

    test('getMaxLengthBasedOnMask_WithNoMask_ReturnsMinusOne', () {
      expect(Formatter.getMaxLengthBasedOnMask(null), equals(-1));
    });
  });
}
