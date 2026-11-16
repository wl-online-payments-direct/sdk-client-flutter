/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2026 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */

/// Represents a SurchargeRate object.
class SurchargeRate {
  final String? _surchargeProductTypeId;

  final String? _surchargeProductTypeVersion;

  final double? _adValoremRate;

  final int? _specificRate;

  SurchargeRate(
    String surchargeProductTypeId,
    String surchargeProductTypeVersion,
    double adValoremRate,
    int specificRate,
  )   : _surchargeProductTypeId = surchargeProductTypeId,
        _surchargeProductTypeVersion = surchargeProductTypeVersion,
        _adValoremRate = adValoremRate,
        _specificRate = specificRate;

  SurchargeRate._fromApi(
    this._surchargeProductTypeId,
    this._surchargeProductTypeVersion,
    this._adValoremRate,
    this._specificRate,
  );

  /// The getters below throw a [StateError] when the API response did not contain the value.
  String get surchargeProductTypeId => _surchargeProductTypeId ?? (throw _absent('surchargeProductTypeId'));

  String get surchargeProductTypeVersion =>
      _surchargeProductTypeVersion ?? (throw _absent('surchargeProductTypeVersion'));

  double get adValoremRate => _adValoremRate ?? (throw _absent('adValoremRate'));

  int get specificRate => _specificRate ?? (throw _absent('specificRate'));

  factory SurchargeRate.fromJson(Map<String, dynamic> json) => SurchargeRate._fromApi(
        json['surchargeProductTypeId'] as String?,
        json['surchargeProductTypeVersion'] as String?,
        (json['adValoremRate'] as num?)?.toDouble(),
        (json['specificRate'] as num?)?.toInt(),
      );

  static StateError _absent(String field) => StateError('The surcharge rate has no $field.');
}
