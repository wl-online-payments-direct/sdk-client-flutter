import 'package:flutter_test/flutter_test.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

void main() {
  test("getBasicPaymentProductById - correct product", () {
    final product = BasicPaymentProduct("1", "card", null, true, true, false);
    final products = BasicPaymentProducts([product]);

    final result = products.getBasicPaymentProductById("1");
    expect(result, isNotNull);

    expect(result!.id, "1");
  });

  test("getBasicPaymentProductById - product does not exist", () {
    final product = BasicPaymentProduct("1", "card", null, true, true, false);
    final products = BasicPaymentProducts([product]);

    final result = products.getBasicPaymentProductById("1111");
    expect(result, isNull);
  });

  test("getBasicPaymentProductByAccountOnFieldId - correct product", () {
    final account = AccountOnFile("123", "3", attributes: []);
    final product = BasicPaymentProduct("1", "card", null, true, true, false, accountsOnFile: [account]);
    final products = BasicPaymentProducts([product]);

    final result = products.getBasicPaymentProductByAccountOnFileId("123");
    expect(result, isNotNull);
    expect(result!.id, "1");
  });

  test("getBasicPaymentProductByAccountOnFieldId - account does not exist", () {
    final account = AccountOnFile("123", "3", attributes: []);
    final product = BasicPaymentProduct("1", "card", null, true, true, false, accountsOnFile: [account]);
    final products = BasicPaymentProducts([product]);

    final result = products.getBasicPaymentProductByAccountOnFileId("1111");
    expect(result, isNull);
  });

  test("accountOnFile returns merged list", () {
    final account1 = AccountOnFile("1", "3", attributes: []);
    final account2 = AccountOnFile("2", "3", attributes: []);

    final product1 = BasicPaymentProduct("1", "card", null, true, true, false, accountsOnFile: [account1]);
    final product2 = BasicPaymentProduct("2", "card", null, true, true, false, accountsOnFile: [account2]);

    final products = BasicPaymentProducts([product1, product2]);

    expect(products.accountsOnFile.length, 2);
    expect(products.accountsOnFile.map((a) => a.id), containsAll(["1", "2"]));
  });

  test("accountOnFile - no accounts in products", () {
    final product1 = BasicPaymentProduct("1", "card", null, true, true, false);
    final product2 = BasicPaymentProduct("2", "card", null, true, true, false);
    final products = BasicPaymentProducts([product1, product2]);

    expect(products.accountsOnFile, isEmpty);
  });
}
