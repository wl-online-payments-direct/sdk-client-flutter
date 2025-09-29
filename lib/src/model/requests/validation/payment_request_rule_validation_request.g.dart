// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_request_rule_validation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentRequestRuleValidationRequest
_$PaymentRequestRuleValidationRequestFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['paymentRequest', 'fieldId', 'rule']);
  return PaymentRequestRuleValidationRequest(
    PaymentRequest.fromJson(json['paymentRequest'] as Map<String, dynamic>),
    json['fieldId'] as String,
    ValidationRule.fromJson(json['rule'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PaymentRequestRuleValidationRequestToJson(
  PaymentRequestRuleValidationRequest instance,
) => <String, dynamic>{
  'paymentRequest': instance.paymentRequest.toJson(),
  'fieldId': instance.fieldId,
  'rule': instance.rule.toJson(),
};
