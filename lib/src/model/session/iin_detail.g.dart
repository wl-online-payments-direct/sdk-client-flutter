// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iin_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IinDetail _$IinDetailFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['paymentProductId', 'isAllowedInContext', 'cardType'],
  );
  return IinDetail(
    json['paymentProductId'] as String,
    json['isAllowedInContext'] as bool,
    $enumDecode(_$CardTypeEnumMap, json['cardType']),
  );
}

Map<String, dynamic> _$IinDetailToJson(IinDetail instance) => <String, dynamic>{
  'paymentProductId': instance.paymentProductId,
  'isAllowedInContext': instance.isAllowedInContext,
  'cardType': _$CardTypeEnumMap[instance.cardType]!,
};

const _$CardTypeEnumMap = {
  CardType.credit: 'Credit',
  CardType.debit: 'Debit',
  CardType.prepaid: 'Prepaid',
};
