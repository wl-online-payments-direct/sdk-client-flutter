// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProduct _$PaymentProductFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['fields'],
  );
  return PaymentProduct(
    json['id'] as String,
    json['paymentMethod'] as String,
    json['paymentProductGroup'] as String?,
    json['allowsRecurring'] as bool,
    json['allowsTokenization'] as bool,
    json['usesRedirectionTo3rdParty'] as bool,
    displayHintsList: (json['displayHintsList'] as List<dynamic>?)
            ?.map((e) =>
                PaymentProductDisplayHints.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
    accountsOnFile: (json['accountsOnFile'] as List<dynamic>?)
            ?.map((e) => AccountOnFile.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
    paymentProduct302SpecificData: json['paymentProduct302SpecificData'] == null
        ? null
        : PaymentProduct302SpecificData.fromJson(
            json['paymentProduct302SpecificData'] as Map<String, dynamic>),
    paymentProduct320SpecificData: json['paymentProduct320SpecificData'] == null
        ? null
        : PaymentProduct320SpecificData.fromJson(
            json['paymentProduct320SpecificData'] as Map<String, dynamic>),
    fields: (json['fields'] as List<dynamic>?)
            ?.map(
                (e) => PaymentProductField.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
  );
}

Map<String, dynamic> _$PaymentProductToJson(PaymentProduct instance) =>
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
      'fields': instance.fields.map((e) => e.toJson()).toList(),
    };
