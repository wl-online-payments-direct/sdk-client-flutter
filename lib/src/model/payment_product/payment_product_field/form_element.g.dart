// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormElement _$FormElementFromJson(Map<String, dynamic> json) =>
    FormElement($enumDecode(_$FormElementTypeEnumMap, json['type']));

Map<String, dynamic> _$FormElementToJson(FormElement instance) =>
    <String, dynamic>{'type': _$FormElementTypeEnumMap[instance.type]!};

const _$FormElementTypeEnumMap = {
  FormElementType.text: 'text',
  FormElementType.list: 'list',
  FormElementType.currency: 'currency',
  FormElementType.date: 'date',
  FormElementType.boolean: 'boolean',
};
