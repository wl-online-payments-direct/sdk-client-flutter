// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iin_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IinDetailsResponse _$IinDetailsResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['status', 'cardType'],
  );
  return IinDetailsResponse(
    $enumDecode(_$IinStatusEnumMap, json['status']),
    $enumDecode(_$CardTypeEnumMap, json['cardType']),
    paymentProductId: json['paymentProductId'] as String?,
    countryCode: json['countryCode'] as String?,
    isAllowedInContext: json['isAllowedInContext'] as bool,
    coBrands: (json['coBrands'] as List<dynamic>?)
            ?.map((e) => IinDetail.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
  );
}

Map<String, dynamic> _$IinDetailsResponseToJson(IinDetailsResponse instance) =>
    <String, dynamic>{
      'status': _$IinStatusEnumMap[instance.status]!,
      'paymentProductId': instance.paymentProductId,
      'countryCode': instance.countryCode,
      'isAllowedInContext': instance.isAllowedInContext,
      'coBrands': instance.coBrands.map((e) => e.toJson()).toList(),
      'cardType': _$CardTypeEnumMap[instance.cardType]!,
    };

const _$IinStatusEnumMap = {
  IinStatus.supported: 'SUPPORTED',
  IinStatus.unknown: 'UNKNOWN',
  IinStatus.notEnoughDigits: 'NOT_ENOUGH_DIGITS',
  IinStatus.existingButNotAllowed: 'EXISTING_BUT_NOT_ALLOWED',
};

const _$CardTypeEnumMap = {
  CardType.credit: 'Credit',
  CardType.debit: 'Debit',
  CardType.prepaid: 'Prepaid',
};
