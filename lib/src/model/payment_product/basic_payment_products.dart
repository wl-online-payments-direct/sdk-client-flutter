/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2023 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:online_payments_sdk/online_payments_sdk.dart';

part 'basic_payment_products.g.dart';

/// Contains a list of [BasicPaymentProduct], a list of [AccountOnFile] and helper methods to retrieve a specific [BasicPaymentProduct] object.
@JsonSerializable(explicitToJson: true)
class BasicPaymentProducts {
  @JsonKey(name: "paymentProducts")
  final List<BasicPaymentProduct> products;

  final List<AccountOnFile> _accountsOnFile = List.empty(growable: true);

  BasicPaymentProducts(this.products) {
    products.sort();
    _getAccountsOnFile();
  }

  factory BasicPaymentProducts.fromJson(Map<String, dynamic> json) =>
      _$BasicPaymentProductsFromJson(json);

  Map<String, dynamic> toJson() => _$BasicPaymentProductsToJson(this);

  List<AccountOnFile> get accountsOnFile => _getAccountsOnFile();
  List<BasicPaymentProduct> get basicPaymentProducts => products;

  /// Returns the [BasicPaymentProduct] with the corresponding [id], or null if not found.
  BasicPaymentProduct? getBasicPaymentProductById(String id) {
    for (BasicPaymentProduct product in products) {
      if (product.id == id) {
        return product;
      }
    }
    return null;
  }

  /// Returns the [BasicPaymentProduct] with the corresponding [accountOnFileId], or null if not found.
  BasicPaymentProduct? getBasicPaymentProductByAccountOnFileId(
    String accountOnFileId,
  ) {
    for (BasicPaymentProduct product in products) {
      for (AccountOnFile accountOnFile in product.accountsOnFile) {
        if (accountOnFile.id == accountOnFileId) {
          return product;
        }
      }
    }
    return null;
  }

  List<AccountOnFile> _getAccountsOnFile() {
    if (_accountsOnFile.isEmpty) {
      for (BasicPaymentProduct product in products) {
        _accountsOnFile.addAll(product.accountsOnFile);
      }
    }
    return _accountsOnFile;
  }
}
