import 'package:flutter_test/flutter_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

void main() {
  test('compareBasicPaymentProducts', () {
    final product1 = BasicPaymentProduct(
      '1',
      'card',
      null,
      true,
      true,
      false,
      displayHintsList: [PaymentProductDisplayHints("VISA", displayOrder: 1, logoUrl: 'visa_logo')],
    );

    final product2 = BasicPaymentProduct(
      '2',
      'card',
      null,
      true,
      true,
      false,
      displayHintsList: [PaymentProductDisplayHints("MASTERCARD", displayOrder: 2, logoUrl: "mastercard_logo")],
    );

    expect(product1.compareTo(product2) < 0, true);
    expect(product2.compareTo(product1) > 0, true);
    expect(product1.compareTo(product1), 0);
  });
}
