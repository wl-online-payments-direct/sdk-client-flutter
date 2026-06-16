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
import '../account_on_file/account_on_file_dto.dart';
import 'display_hints/payment_product_display_hints_dto.dart';
import 'payment_product_field_dto.dart';

class PaymentProductDto {
  final int? id;
  final String paymentMethod;
  final String? paymentProductGroup;
  final bool? allowsRecurring;
  final bool? allowsTokenization;
  final bool? usesRedirectionTo3rdParty;
  final int? maxAmount;
  final int? minAmount;
  final PaymentProductDisplayHintsDto displayHints;
  final List<AccountOnFileDto> accountsOnFile;
  final bool? allowsInstallments;
  final bool? isJavaScriptRequired;
  final bool? allowsAuthentication;
  final Map<String, dynamic>? paymentProduct302SpecificData;
  final Map<String, dynamic>? paymentProduct320SpecificData;
  final List<PaymentProductFieldDto> fields;

  PaymentProductDto({
    required this.id,
    required this.paymentMethod,
    this.paymentProductGroup,
    this.allowsRecurring,
    this.allowsTokenization,
    this.usesRedirectionTo3rdParty,
    this.maxAmount,
    this.minAmount,
    required this.displayHints,
    this.accountsOnFile = const [],
    this.allowsInstallments,
    this.isJavaScriptRequired,
    this.allowsAuthentication,
    this.paymentProduct302SpecificData,
    this.paymentProduct320SpecificData,
    this.fields = const [],
  });

  factory PaymentProductDto.fromJson(Map<String, dynamic> json) {
    final directDisplayHints = json['displayHints'];
    final displayHintsList = json['displayHintsList'] as List<dynamic>?;
    final resolvedDisplayHints = directDisplayHints is Map<String, dynamic>
        ? directDisplayHints
        : displayHintsList != null && displayHintsList.isNotEmpty
            ? displayHintsList.first as Map<String, dynamic>
            : <String, dynamic>{};

    return PaymentProductDto(
      id: (json['id'] as num?)?.toInt(),
      paymentMethod: json['paymentMethod'] as String? ?? '',
      paymentProductGroup: json['paymentProductGroup'] as String?,
      allowsRecurring: json['allowsRecurring'] as bool?,
      allowsTokenization: json['allowsTokenization'] as bool?,
      usesRedirectionTo3rdParty: json['usesRedirectionTo3rdParty'] as bool?,
      maxAmount: (json['maxAmount'] as num?)?.toInt(),
      minAmount: (json['minAmount'] as num?)?.toInt(),
      displayHints: PaymentProductDisplayHintsDto.fromJson(resolvedDisplayHints),
      accountsOnFile: (json['accountsOnFile'] as List<dynamic>? ?? [])
          .map((e) => AccountOnFileDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      allowsInstallments: json['allowsInstallments'] as bool?,
      isJavaScriptRequired: json['isJavaScriptRequired'] as bool?,
      allowsAuthentication: json['allowsAuthentication'] as bool?,
      paymentProduct302SpecificData: json['paymentProduct302SpecificData'] as Map<String, dynamic>?,
      paymentProduct320SpecificData: json['paymentProduct320SpecificData'] as Map<String, dynamic>?,
      fields: (json['fields'] as List<dynamic>? ?? [])
          .map((e) => PaymentProductFieldDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
