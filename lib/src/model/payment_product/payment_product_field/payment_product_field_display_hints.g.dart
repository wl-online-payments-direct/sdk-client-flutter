// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_product_field_display_hints.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProductFieldDisplayHints _$PaymentProductFieldDisplayHintsFromJson(
        Map<String, dynamic> json) =>
    PaymentProductFieldDisplayHints(
      json['alwaysShow'] as bool,
      json['obfuscate'] as bool,
      (json['displayOrder'] as num).toInt(),
      json['label'] as String?,
      json['placeholderLabel'] as String,
      json['mask'] as String?,
      $enumDecodeNullable(
          _$PreferredInputTypeEnumMap, json['preferredInputType']),
      json['tooltip'] == null
          ? null
          : Tooltip.fromJson(json['tooltip'] as Map<String, dynamic>),
      json['formElement'] == null
          ? null
          : FormElement.fromJson(json['formElement'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentProductFieldDisplayHintsToJson(
        PaymentProductFieldDisplayHints instance) =>
    <String, dynamic>{
      'alwaysShow': instance.alwaysShow,
      'obfuscate': instance.obfuscate,
      'displayOrder': instance.displayOrder,
      'label': instance.label,
      'placeholderLabel': instance.placeholderLabel,
      'mask': instance.mask,
      'preferredInputType':
          _$PreferredInputTypeEnumMap[instance.preferredInputType],
      'tooltip': instance.tooltip?.toJson(),
      'formElement': instance.formElement?.toJson(),
    };

const _$PreferredInputTypeEnumMap = {
  PreferredInputType.integerKeyboard: 'IntegerKeyboard',
  PreferredInputType.stringKeyboard: 'StringKeyboard',
  PreferredInputType.phoneNumberKeyboard: 'PhoneNumberKeyboard',
  PreferredInputType.emailAddressKeyboard: 'EmailAddressKeyboard',
  PreferredInputType.datePicker: 'DateKeyboard',
};
