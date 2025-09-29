// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_on_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountOnFile _$AccountOnFileFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['id', 'paymentProductId']);
  return AccountOnFile(
    json['id'] as String,
    json['paymentProductId'] as String,
    displayHints: json['displayHints'] == null
        ? null
        : AccountOnFileDisplayHints.fromJson(
            json['displayHints'] as Map<String, dynamic>,
          ),
    attributes:
        (json['attributes'] as List<dynamic>?)
            ?.map(
              (e) => AccountOnFileAttribute.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        const [],
    label: json['label'] as String? ?? "",
  );
}

Map<String, dynamic> _$AccountOnFileToJson(AccountOnFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paymentProductId': instance.paymentProductId,
      'displayHints': instance.displayHints?.toJson(),
      'attributes': instance.attributes.map((e) => e.toJson()).toList(),
      'label': instance.label,
    };
