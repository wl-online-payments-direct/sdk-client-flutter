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
import 'specific_data/payment_product_302_specific_data.dart';
import 'specific_data/payment_product_320_specific_data.dart';

/// Represents a BasicPaymentProduct object.
class BasicPaymentProduct implements Comparable<BasicPaymentProduct> {
  final int? id;

  final String paymentMethod;

  final String? paymentProductGroup;

  final bool? allowsRecurring;

  final bool? allowsTokenization;

  final bool? usesRedirectionTo3rdParty;

  final String? label;

  final String? logo;

  final int? displayOrder;

  final int? maxAmount;

  final int? minAmount;

  final PaymentProduct302SpecificData? paymentProduct302SpecificData;

  final PaymentProduct320SpecificData? paymentProduct320SpecificData;

  final List<AccountOnFile> accountsOnFile;

  BasicPaymentProduct(
    this.id,
    this.paymentMethod, {
    this.paymentProductGroup,
    this.allowsRecurring,
    this.allowsTokenization,
    this.usesRedirectionTo3rdParty,
    this.label,
    this.logo,
    this.displayOrder,
    this.maxAmount,
    this.minAmount,
    this.paymentProduct302SpecificData,
    this.paymentProduct320SpecificData,
    this.accountsOnFile = const [],
  });

  /// Returns the [AccountOnFile] with the given [id], or null if not found.
  AccountOnFile? getAccountOnFile(String id) {
    return accountsOnFile.where((a) => a.id == id).firstOrNull;
  }

  @override
  int compareTo(BasicPaymentProduct other) {
    final a = displayOrder ?? 0;
    final b = other.displayOrder ?? 0;

    return a.compareTo(b);
  }
}

