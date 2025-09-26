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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_payments_repository/providers/payment_product_state_provider.dart';
import 'package:online_payments_repository/strings.dart' as strings;
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk_example/extensions/generic_extensions.dart';
import 'package:online_payments_sdk_example/pages/payment_product/components/account_on_file_info.dart';
import 'package:online_payments_sdk_example/reusable_components/bold_expansion_tile.dart';
import 'package:online_payments_sdk_example/reusable_components/default_padding.dart';
import 'package:online_payments_sdk_example/reusable_components/default_text.dart';
import 'package:online_payments_sdk_example/reusable_components/expansion_padding.dart';
import 'package:online_payments_sdk_example/reusable_components/label_value_row.dart';
import 'package:online_payments_sdk_example/reusable_components/vertical_scroll_view.dart';

import 'components/payment_product_field_info.dart';

/// This basic example only shows how to initialize a Session and how to make a Payment Product call.
/// A more extensive example - which shows the complete flow of how to create a payment - can be found at https://github.com/wl-online-payments-direct/sdk-client-flutter-example.
class PaymentProductPage extends ConsumerWidget {
  const PaymentProductPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const PaymentProductPage());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentProduct =
        ref.read(paymentProductStateProvider).data as PaymentProduct?;

    return VerticalScrollView(
      childWidget: Column(
        children: [
          if (paymentProduct != null) ...[
            paymentProduct.displayHintsList[0].label.runIfNotNull(
              (label) {
                return DefaultText(
                  label,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                );
              },
              onNull: const DefaultText(
                strings.paymentProductLabelNotFound,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const DefaultPadding(),
            _GeneralPaymentProductInfo(paymentProduct: paymentProduct),
            const DefaultPadding(),
            BoldExpansionTile(
              title: strings.displayHintsListLabel,
              backgroundColor: Colors.green,
              children: [
                for (final displayHints in paymentProduct.displayHintsList)
                  ExpansionPadding(
                      child: _DisplayHintsInfo(displayHints: displayHints)),
              ],
            ),
            paymentProduct.paymentProduct302SpecificData.runIfNotNull(
              (specific302Data) {
                return Column(children: [
                  const DefaultPadding(),
                  BoldExpansionTile(
                    title: strings.specific302DataLabel,
                    backgroundColor: Colors.green,
                    children: [
                      ExpansionPadding(
                        child: _Specific302DataInfo(
                          specificData: specific302Data,
                        ),
                      )
                    ],
                  )
                ]);
              },
            ),
            paymentProduct.paymentProduct320SpecificData.runIfNotNull(
              (specific320Data) {
                return Column(children: [
                  const DefaultPadding(),
                  BoldExpansionTile(
                    title: strings.specific320DataLabel,
                    backgroundColor: Colors.green,
                    children: [
                      ExpansionPadding(
                          child: _Specific320DataInfo(
                        specificData: specific320Data,
                      ))
                    ],
                  ),
                ]);
              },
            ),
            if (paymentProduct.accountsOnFile.isNotEmpty) ...[
              const DefaultPadding(),
              BoldExpansionTile(
                title: strings.accountsOnFileLabel,
                backgroundColor: Colors.green,
                children: [
                  ExpansionPadding(
                    child: AccountsOnFileInfo(
                      accountsOnFile: paymentProduct.accountsOnFile,
                    ),
                  )
                ],
              ),
            ],
            if (paymentProduct.fields.isNotEmpty) ...[
              const DefaultPadding(),
              BoldExpansionTile(
                title: strings.paymentProductFieldsLabel,
                backgroundColor: Colors.green,
                children: [
                  ExpansionPadding(
                      child: PaymentProductFieldsInfo(
                    paymentProductFields: paymentProduct.fields,
                  ))
                ],
              ),
            ],
          ] else
            const Text(strings.paymentProductNotFound)
        ],
      ),
    );
  }
}

class _ProductLogo extends StatelessWidget {
  final String logoUrl;

  const _ProductLogo({required this.logoUrl});

  @override
  Widget build(BuildContext context) {
    if (logoUrl.isNotEmpty) {
      return SizedBox(
        height: 100,
        width: 100,
        child: Image.network(
          logoUrl,
          errorBuilder: (context, exception, stacktrace) => Container(),
        ),
      );
    }

    return Container();
  }
}

class _GeneralPaymentProductInfo extends StatelessWidget {
  final PaymentProduct paymentProduct;

  const _GeneralPaymentProductInfo({required this.paymentProduct});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabelValueRow(label: strings.productIdLabel, value: paymentProduct.id),
        LabelValueRow(
          label: strings.paymentMethodLabel,
          value: paymentProduct.paymentMethod,
        ),
        paymentProduct.paymentProductGroup.runIfNotNull(
          (paymentProductGroup) => LabelValueRow(
            label: strings.paymentProductGroupLabel,
            value: paymentProductGroup,
          ),
        ),
        LabelValueRow(
          label: strings.allowsRecurringLabel,
          value: paymentProduct.allowsRecurring.toString(),
        ),
        LabelValueRow(
          label: strings.allowsTokenizationLabel,
          value: paymentProduct.allowsTokenization.toString(),
        ),
        LabelValueRow(
          label: strings.usesRedirectionThirdPartyLabel,
          value: paymentProduct.usesRedirectionTo3rdParty.toString(),
        ),
      ],
    );
  }
}

class _DisplayHintsInfo extends StatelessWidget {
  final PaymentProductDisplayHints displayHints;

  const _DisplayHintsInfo({required this.displayHints});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelValueRow(
          label: strings.displayOderLabel,
          value: displayHints.displayOrder.toString(),
          textColor: Colors.white,
        ),
        LabelValueRow(
          label: strings.labelLabel,
          value: displayHints.label,
          textColor: Colors.white,
        ),
        const DefaultText(
          strings.logoLabel,
          fontWeight: FontWeight.bold,
          textColor: Colors.white,
        ),
        displayHints.logoUrl
            .runIfNotNull((logoUrl) => _ProductLogo(logoUrl: logoUrl))
      ],
    );
  }
}

class _Specific302DataInfo extends StatelessWidget {
  final PaymentProduct302SpecificData specificData;

  const _Specific302DataInfo({required this.specificData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DefaultText(
          strings.networksLabel,
          textColor: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        for (final network in specificData.networks)
          DefaultText(
            "- $network",
            textColor: Colors.white,
          ),
        Container()
      ],
    );
  }
}

class _Specific320DataInfo extends StatelessWidget {
  final PaymentProduct320SpecificData specificData;

  const _Specific320DataInfo({required this.specificData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DefaultText(
          strings.networksLabel,
          textColor: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        for (final network in specificData.networks)
          DefaultText(
            "- $network",
            textColor: Colors.white,
          ),
        LabelValueRow(
          label: strings.gatewayLabel,
          value: specificData.gateway,
          textColor: Colors.white,
        )
      ],
    );
  }
}
