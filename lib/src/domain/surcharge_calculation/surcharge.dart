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

import '../amount_of_money.dart';
import 'surcharge_rate.dart';
import 'surcharge_result.dart';

/// Represents a Surcharge object.
class Surcharge {
  final int? _paymentProductId;

  final SurchargeResult result;

  final AmountOfMoney? _netAmount;

  final AmountOfMoney? _surchargeAmount;

  final AmountOfMoney? _totalAmount;

  final SurchargeRate? surchargeRate;

  Surcharge(
    int paymentProductId,
    this.result,
    AmountOfMoney netAmount,
    AmountOfMoney surchargeAmount,
    AmountOfMoney totalAmount, {
    this.surchargeRate,
  })  : _paymentProductId = paymentProductId,
        _netAmount = netAmount,
        _surchargeAmount = surchargeAmount,
        _totalAmount = totalAmount;

  Surcharge._fromApi(
    this._paymentProductId,
    this.result,
    this._netAmount,
    this._surchargeAmount,
    this._totalAmount, {
    this.surchargeRate,
  });

  /// The getters below throw a [StateError] when the API response did not contain the value.
  int get paymentProductId => _paymentProductId ?? (throw _absent('paymentProductId'));

  AmountOfMoney get netAmount => _netAmount ?? (throw _absent('netAmount'));

  AmountOfMoney get surchargeAmount => _surchargeAmount ?? (throw _absent('surchargeAmount'));

  AmountOfMoney get totalAmount => _totalAmount ?? (throw _absent('totalAmount'));

  factory Surcharge.fromJson(Map<String, dynamic> json) => Surcharge._fromApi(
        (json['paymentProductId'] as num?)?.toInt(),
        SurchargeResult.fromString(json['result'] as String? ?? ''),
        _amountOrNull(json['netAmount']),
        _amountOrNull(json['surchargeAmount']),
        _amountOrNull(json['totalAmount']),
        surchargeRate: json['surchargeRate'] != null
            ? SurchargeRate.fromJson(json['surchargeRate'] as Map<String, dynamic>)
            : null,
      );

  static AmountOfMoney? _amountOrNull(Object? json) =>
      json != null ? AmountOfMoney.fromJson(json as Map<String, dynamic>) : null;

  static StateError _absent(String field) => StateError('The surcharge has no $field.');
}
