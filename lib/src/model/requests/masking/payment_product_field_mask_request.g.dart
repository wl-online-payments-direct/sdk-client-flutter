// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_product_field_mask_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProductFieldMaskRequest _$PaymentProductFieldMaskRequestFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['field', 'value'],
  );
  return PaymentProductFieldMaskRequest(
    PaymentProductField.fromJson(json['field'] as Map<String, dynamic>),
    json['value'] as String,
  );
}

Map<String, dynamic> _$PaymentProductFieldMaskRequestToJson(
        PaymentProductFieldMaskRequest instance) =>
    <String, dynamic>{
      'field': instance.field.toJson(),
      'value': instance.value,
    };
