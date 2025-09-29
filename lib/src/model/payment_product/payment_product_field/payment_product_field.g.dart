// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_product_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProductField _$PaymentProductFieldFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['id', 'type']);
  return PaymentProductField(
    json['id'] as String,
    $enumDecode(_$PaymentProductFieldTypeEnumMap, json['type']),
    displayHints: json['displayHints'] == null
        ? const PaymentProductFieldDisplayHints.empty()
        : PaymentProductFieldDisplayHints.fromJson(
            json['displayHints'] as Map<String, dynamic>,
          ),
    dataRestrictions: json['dataRestrictions'] == null
        ? const DataRestrictions.empty()
        : DataRestrictions.fromJson(
            json['dataRestrictions'] as Map<String, dynamic>,
          ),
  );
}

Map<String, dynamic> _$PaymentProductFieldToJson(
  PaymentProductField instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$PaymentProductFieldTypeEnumMap[instance.type]!,
  'displayHints': instance.displayHints?.toJson(),
  'dataRestrictions': instance.dataRestrictions.toJson(),
};

const _$PaymentProductFieldTypeEnumMap = {
  PaymentProductFieldType.string: 'string',
  PaymentProductFieldType.integer: 'integer',
  PaymentProductFieldType.numericString: 'numericstring',
  PaymentProductFieldType.expiryDate: 'expirydate',
  PaymentProductFieldType.boolean: 'boolean',
  PaymentProductFieldType.date: 'date',
  PaymentProductFieldType.tel: 'tel',
  PaymentProductFieldType.text: 'text',
};
