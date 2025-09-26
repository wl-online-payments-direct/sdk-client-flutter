// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_product_display_hints.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProductDisplayHints _$PaymentProductDisplayHintsFromJson(
        Map<String, dynamic> json) =>
    PaymentProductDisplayHints(
      json['label'] as String,
      displayOrder: (json['displayOrder'] as num).toInt(),
      logoUrl: json['logo'] as String,
    );

Map<String, dynamic> _$PaymentProductDisplayHintsToJson(
        PaymentProductDisplayHints instance) =>
    <String, dynamic>{
      'displayOrder': instance.displayOrder,
      'label': instance.label,
      'logo': instance.logoUrl,
    };
