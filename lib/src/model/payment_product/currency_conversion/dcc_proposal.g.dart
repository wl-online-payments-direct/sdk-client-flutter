// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dcc_proposal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DccProposal _$DccProposalFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['baseAmount', 'targetAmount', 'rate'],
  );
  return DccProposal(
    AmountOfMoney.fromJson(json['baseAmount'] as Map<String, dynamic>),
    AmountOfMoney.fromJson(json['targetAmount'] as Map<String, dynamic>),
    RateDetails.fromJson(json['rate'] as Map<String, dynamic>),
    disclaimerReceipt: json['disclaimerReceipt'] as String?,
    disclaimerDisplay: json['disclaimerDisplay'] as String?,
  );
}

Map<String, dynamic> _$DccProposalToJson(DccProposal instance) =>
    <String, dynamic>{
      'baseAmount': instance.baseAmount.toJson(),
      'targetAmount': instance.targetAmount.toJson(),
      'rate': instance.rate.toJson(),
      'disclaimerReceipt': instance.disclaimerReceipt,
      'disclaimerDisplay': instance.disclaimerDisplay,
    };
