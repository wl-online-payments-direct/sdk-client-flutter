/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2025 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import 'package:flutter/material.dart';
import 'package:online_payments_repository/strings.dart' as strings;
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk_example/extensions/generic_extensions.dart';
import 'package:online_payments_sdk_example/reusable_components/bold_expansion_tile.dart';
import 'package:online_payments_sdk_example/reusable_components/default_padding.dart';
import 'package:online_payments_sdk_example/reusable_components/default_text.dart';
import 'package:online_payments_sdk_example/reusable_components/expansion_padding.dart';
import 'package:online_payments_sdk_example/reusable_components/label_value_row.dart';
import 'package:online_payments_sdk_example/reusable_components/next_line_value.dart';

class PaymentProductFieldsInfo extends StatelessWidget {
  final List<PaymentProductField> paymentProductFields;

  const PaymentProductFieldsInfo({
    super.key,
    required this.paymentProductFields,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final ppf in paymentProductFields) ...[
          _PaymentProductFieldExpansion(
            paymentProductField: ppf,
          ),
          const DefaultPadding()
        ]
      ],
    );
  }
}

class _PaymentProductFieldExpansion extends StatelessWidget {
  final PaymentProductField paymentProductField;

  const _PaymentProductFieldExpansion({required this.paymentProductField});

  @override
  Widget build(BuildContext context) {
    return BoldExpansionTile(
      title: "${strings.paymentProductFieldLabel} - ${paymentProductField.id}",
      backgroundColor: Colors.green.shade700,
      children: [
        ExpansionPadding(
          child: _PaymentProductFieldInfo(
            paymentProductField: paymentProductField,
          ),
        )
      ],
    );
  }
}

class _PaymentProductFieldInfo extends StatelessWidget {
  final PaymentProductField paymentProductField;

  const _PaymentProductFieldInfo({required this.paymentProductField});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        LabelValueRow(
          label: strings.typeLabel,
          value: paymentProductField.type.name,
          textColor: Colors.white,
        ),
        const DefaultPadding(),
        _DataRestrictionsInfo(
          dataRestrictions: paymentProductField.dataRestrictions,
        ),
        const DefaultPadding(),
        paymentProductField.displayHints.runIfNotNull(
          (displayHints) => _DisplayHintsInfo(displayHints: displayHints),
        ),
        const DefaultPadding()
      ],
    );
  }
}

class _DataRestrictionsInfo extends StatelessWidget {
  final DataRestrictions dataRestrictions;

  const _DataRestrictionsInfo({required this.dataRestrictions});

  @override
  Widget build(BuildContext context) {
    return BoldExpansionTile(
      title: strings.dataRestrictionsLabel,
      backgroundColor: Colors.green.shade800,
      children: [
        ExpansionPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelValueRow(
                label: strings.requiredLabel,
                value: dataRestrictions.isRequired.toString(),
                textColor: Colors.white,
              ),
              const DefaultText(
                strings.validationRulesLabel,
                textColor: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              for (final validationRule in dataRestrictions.validators.keys)
                DefaultText(
                  "- $validationRule",
                  textColor: Colors.white,
                ),
            ],
          ),
        )
      ],
    );
  }
}

class _DisplayHintsInfo extends StatelessWidget {
  final PaymentProductFieldDisplayHints displayHints;

  const _DisplayHintsInfo({required this.displayHints});

  @override
  Widget build(BuildContext context) {
    return BoldExpansionTile(
      title: strings.displayHintsLabel,
      backgroundColor: Colors.green.shade800,
      children: [
        ExpansionPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelValueRow(
                label: strings.alwaysShowLabel,
                value: displayHints.alwaysShow.toString(),
                textColor: Colors.white,
              ),
              LabelValueRow(
                label: strings.displayOderLabel,
                value: displayHints.displayOrder.toString(),
                textColor: Colors.white,
              ),
              displayHints.formElement.runIfNotNull(
                (formElement) => LabelValueRow(
                  label: strings.formElementTypeLabel,
                  value: formElement.type.name,
                  textColor: Colors.white,
                ),
              ),
              displayHints.label.runIfNotNull(
                (label) => LabelValueRow(
                  label: strings.labelLabel,
                  value: label,
                  textColor: Colors.white,
                ),
              ),
              displayHints.mask.runIfNotNull(
                (mask) => NextLineValue(
                  label: strings.maskLabel,
                  value: mask,
                ),
              ),
              LabelValueRow(
                label: strings.obfuscateLabel,
                value: displayHints.obfuscate.toString(),
                textColor: Colors.white,
              ),
              LabelValueRow(
                label: strings.placeholderLabel,
                value: displayHints.placeholderLabel,
                textColor: Colors.white,
              ),
              displayHints.preferredInputType.runIfNotNull(
                (preferredInputType) => NextLineValue(
                  label: strings.preferredInputTypeLabel,
                  value: preferredInputType.name,
                ),
              ),
              displayHints.tooltip.runIfNotNull(
                (tooltip) => NextLineValue(
                  label: strings.tooltipLabel,
                  value: tooltip.label,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
