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

/// Represents display hints for a [PaymentProductField].
class ProductFieldDisplayHints {
  final bool alwaysShow;

  final bool obfuscate;

  final int displayOrder;

  final String? label;

  final String? placeholderLabel;

  final String? mask;

  final String? preferredInputType;

  final String? tooltipLabel;

  final String? formElementType;

  /// A wildcard version of [mask] with digits replaced by `*`.
  final String wildcardMask;

  ProductFieldDisplayHints({
    this.alwaysShow = false,
    this.obfuscate = false,
    this.displayOrder = 0,
    this.label,
    this.placeholderLabel,
    this.mask,
    this.preferredInputType,
    this.tooltipLabel,
    this.formElementType,
  }) : wildcardMask = mask?.replaceAll('9', '*') ?? '';

  const ProductFieldDisplayHints.empty({
    this.alwaysShow = false,
    this.obfuscate = false,
    this.displayOrder = 0,
    this.label,
    this.placeholderLabel,
    this.mask,
    this.preferredInputType,
    this.tooltipLabel,
    this.formElementType,
  }) : wildcardMask = '';
}

