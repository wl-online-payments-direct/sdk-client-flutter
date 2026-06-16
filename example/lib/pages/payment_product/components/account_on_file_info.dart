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
import 'package:flutter/material.dart';
import 'package:online_payments_repository/strings.dart' as strings;
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk_example/extensions/generic_extensions.dart';
import 'package:online_payments_sdk_example/reusable_components/bold_expansion_tile.dart';
import 'package:online_payments_sdk_example/reusable_components/default_padding.dart';
import 'package:online_payments_sdk_example/reusable_components/expansion_padding.dart';
import 'package:online_payments_sdk_example/reusable_components/label_value_row.dart';

class AccountsOnFileInfo extends StatelessWidget {
  final List<AccountOnFile> accountsOnFile;

  const AccountsOnFileInfo({super.key, required this.accountsOnFile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final aof in accountsOnFile) ...[
          _AccountOnFileInfo(
            accountOnFile: aof,
          ),
          const DefaultPadding()
        ]
      ],
    );
  }
}

class _AccountOnFileInfo extends StatelessWidget {
  final AccountOnFile accountOnFile;

  const _AccountOnFileInfo({required this.accountOnFile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelValueRow(
          label: strings.accountOnFileIdLabel,
          value: accountOnFile.id,
          textColor: Colors.white,
        ),
        LabelValueRow(
          label: strings.productIdLabel,
          value: accountOnFile.paymentProductId.toString(),
          textColor: Colors.white,
        ),
        accountOnFile.label.runIfNotNull(
          (label) => LabelValueRow(
            label: strings.labelLabel,
            value: label,
            textColor: Colors.white,
          ),
        ),
        const DefaultPadding(),
        _AttributesInfo(
          attributes: accountOnFile.attributes,
        ),
      ],
    );
  }
}

class _AttributesInfo extends StatelessWidget {
  final List<AccountOnFileAttribute> attributes;

  const _AttributesInfo({required this.attributes});

  @override
  Widget build(BuildContext context) {
    return BoldExpansionTile(
      title: strings.attributesLabel,
      backgroundColor: Colors.green.shade700,
      children: [
        for (final attribute in attributes) ...[
          ExpansionPadding(child: _AttributeInfo(attribute: attribute)),
          const DefaultPadding()
        ]
      ],
    );
  }
}

class _AttributeInfo extends StatelessWidget {
  final AccountOnFileAttribute attribute;

  const _AttributeInfo({required this.attribute});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelValueRow(
          label: strings.keyLabel,
          value: attribute.key,
          textColor: Colors.white,
        ),
        LabelValueRow(
          label: strings.statusLabel,
          value: attribute.status?.name ?? '',
          textColor: Colors.white,
        ),
        LabelValueRow(
          label: strings.valueLabel,
          value: attribute.value,
          textColor: Colors.white,
        ),
      ],
    );
  }
}
