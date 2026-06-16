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

import '../account_on_file/account_on_file.dart';
import 'basic_payment_product.dart';

/// Contains a list of [BasicPaymentProduct], a list of [AccountOnFile] and helper methods to retrieve a specific [BasicPaymentProduct] object.
class BasicPaymentProducts {
  final List<BasicPaymentProduct> products;

  final List<AccountOnFile> _accountsOnFile = List.empty(growable: true);

  BasicPaymentProducts(this.products) {
    products.sort();
    _getAccountsOnFile();
  }

  List<AccountOnFile> get accountsOnFile => _getAccountsOnFile();

  List<BasicPaymentProduct> get basicPaymentProducts => products;

  /// Returns the [BasicPaymentProduct] with the corresponding [id], or null if not found.
  BasicPaymentProduct? getBasicPaymentProductById(int id) {
    return products.where((p) => p.id == id).firstOrNull;
  }

  /// Returns the [BasicPaymentProduct] with the corresponding [accountOnFileId], or null if not found.
  BasicPaymentProduct? getBasicPaymentProductByAccountOnFileId(String accountOnFileId) {
    for (final BasicPaymentProduct product in products) {
      for (final AccountOnFile accountOnFile in product.accountsOnFile) {
        if (accountOnFile.id == accountOnFileId) {
          return product;
        }
      }
    }

    return null;
  }

  List<AccountOnFile> _getAccountsOnFile() {
    if (_accountsOnFile.isEmpty) {
      for (final BasicPaymentProduct product in products) {
        _accountsOnFile.addAll(product.accountsOnFile);
      }
    }

    return _accountsOnFile;
  }
}
