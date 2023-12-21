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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_payment_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasicPaymentProduct _$BasicPaymentProductFromJson(Map<String, dynamic> json) =>
    BasicPaymentProduct(
      json['id'] as String,
      json['paymentMethod'] as String,
      json['paymentProductGroup'] as String?,
      json['allowsRecurring'] as bool,
      json['allowsTokenization'] as bool,
      json['usesRedirectionTo3rdParty'] as bool,
      displayHintsList: (json['displayHintsList'] as List<dynamic>?)
              ?.map((e) => PaymentProductDisplayHints.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      accountsOnFile: (json['accountsOnFile'] as List<dynamic>?)
              ?.map((e) => AccountOnFile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      paymentProduct320SpecificData: json['paymentProduct320SpecificData'] ==
              null
          ? null
          : PaymentProduct320SpecificData.fromJson(
              json['paymentProduct320SpecificData'] as Map<String, dynamic>),
      paymentProduct302SpecificData: json['paymentProduct302SpecificData'] ==
              null
          ? null
          : PaymentProduct302SpecificData.fromJson(
              json['paymentProduct302SpecificData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BasicPaymentProductToJson(
        BasicPaymentProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paymentMethod': instance.paymentMethod,
      'paymentProductGroup': instance.paymentProductGroup,
      'allowsRecurring': instance.allowsRecurring,
      'allowsTokenization': instance.allowsTokenization,
      'usesRedirectionTo3rdParty': instance.usesRedirectionTo3rdParty,
      'displayHintsList':
          instance.displayHintsList.map((e) => e.toJson()).toList(),
      'accountsOnFile': instance.accountsOnFile.map((e) => e.toJson()).toList(),
      'paymentProduct302SpecificData':
          instance.paymentProduct302SpecificData?.toJson(),
      'paymentProduct320SpecificData':
          instance.paymentProduct320SpecificData?.toJson(),
    };
