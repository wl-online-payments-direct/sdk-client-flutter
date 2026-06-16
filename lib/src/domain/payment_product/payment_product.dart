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

import 'basic_payment_product.dart';
import 'product_field/payment_product_field.dart';

/// Represents a [BasicPaymentProduct] and its [PaymentProductField]s.
class PaymentProduct extends BasicPaymentProduct {
  final List<PaymentProductField> fields;

  PaymentProduct(
    super.id,
    super.paymentMethod, {
    super.paymentProductGroup,
    super.allowsRecurring,
    super.allowsTokenization,
    super.usesRedirectionTo3rdParty,
    super.label,
    super.logo,
    super.displayOrder,
    super.maxAmount,
    super.minAmount,
    super.paymentProduct302SpecificData,
    super.paymentProduct320SpecificData,
    super.accountsOnFile,
    this.fields = const [],
  });

  /// Returns all required [PaymentProductField]s.
  List<PaymentProductField> get requiredFields => fields.where((f) => f.isRequired()).toList();

  /// Returns the [PaymentProductField] with the given [fieldId], or null if not found.
  PaymentProductField? getField(String fieldId) {
    try {
      return fields.firstWhere((f) => f.id == fieldId);
    } catch (_) {
      return null;
    }
  }
}
