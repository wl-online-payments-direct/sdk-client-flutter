// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_error_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationErrorMessage _$ValidationErrorMessageFromJson(
        Map<String, dynamic> json) =>
    ValidationErrorMessage(
      errorMessage: json['errorMessage'] as String,
      paymentProductFieldId: json['paymentProductFieldId'] as String,
      rule: validationRuleFromJson(json['rule']),
    );

Map<String, dynamic> _$ValidationErrorMessageToJson(
        ValidationErrorMessage instance) =>
    <String, dynamic>{
      'errorMessage': instance.errorMessage,
      'paymentProductFieldId': instance.paymentProductFieldId,
      'rule': instance.rule,
    };
