// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_on_file_display_hints.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountOnFileDisplayHints _$AccountOnFileDisplayHintsFromJson(
  Map<String, dynamic> json,
) => AccountOnFileDisplayHints(
  (json['labelTemplate'] as List<dynamic>)
      .map((e) => LabelTemplateElement.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AccountOnFileDisplayHintsToJson(
  AccountOnFileDisplayHints instance,
) => <String, dynamic>{
  'labelTemplate': instance.labelTemplate.map((e) => e.toJson()).toList(),
};
