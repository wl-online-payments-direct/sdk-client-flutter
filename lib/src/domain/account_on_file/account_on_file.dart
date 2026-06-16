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

import 'account_on_file_attribute.dart';

/// Represents an AccountOnFile object.
class AccountOnFile {
  final String id;

  final int paymentProductId;

  /// Display label for the account on file, typically a masked card number.
  final String? label;

  final List<AccountOnFileAttribute> _attributes;

  AccountOnFile(
    this.id,
    this.paymentProductId, {
    this.label,
    List<AccountOnFileAttribute> attributes = const [],
  }) : _attributes = attributes;

  List<AccountOnFileAttribute> get attributes => List.unmodifiable(_attributes);

  /// Returns the value for the field with the given [fieldId], or null if not found.
  String? getValue(String fieldId) {
    try {
      return _attributes.firstWhere((a) => a.key == fieldId).value;
    } catch (_) {
      return null;
    }
  }

  /// Returns the attribute with the given [fieldId], or null if not found.
  AccountOnFileAttribute? getAttribute(String fieldId) {
    try {
      return _attributes.firstWhere((a) => a.key == fieldId);
    } catch (_) {
      return null;
    }
  }

  /// Returns attributes the consumer must fill in.
  List<AccountOnFileAttribute> getRequiredAttributes() {
    return _attributes
        .where((a) => a.status == AccountOnFileAttributeStatus.mustWrite)
        .toList();
  }

  /// Returns attributes the consumer may edit.
  List<AccountOnFileAttribute> getWritableAttributes() {
    return _attributes
        .where((a) => a.status != AccountOnFileAttributeStatus.readOnly)
        .toList();
  }

  /// Returns read-only attributes.
  List<AccountOnFileAttribute> getReadOnlyAttributes() {
    return _attributes
        .where((a) => a.status == AccountOnFileAttributeStatus.readOnly)
        .toList();
  }

  /// Returns whether the field with [fieldId] can be edited.
  bool isWritable(String fieldId) {
    return getAttribute(fieldId)?.status != AccountOnFileAttributeStatus.readOnly;
  }
}

