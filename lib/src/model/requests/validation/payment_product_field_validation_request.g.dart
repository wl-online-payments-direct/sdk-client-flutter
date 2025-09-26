// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_product_field_validation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProductFieldValidationRequest
    _$PaymentProductFieldValidationRequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['value', 'field', 'paymentProduct'],
  );
  return PaymentProductFieldValidationRequest(
    json['value'] as String,
    PaymentProductField.fromJson(json['field'] as Map<String, dynamic>),
    PaymentProduct.fromJson(json['paymentProduct'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PaymentProductFieldValidationRequestToJson(
        PaymentProductFieldValidationRequest instance) =>
    <String, dynamic>{
      'value': instance.value,
      'field': instance.field.toJson(),
      'paymentProduct': instance.paymentProduct.toJson(),
    };
