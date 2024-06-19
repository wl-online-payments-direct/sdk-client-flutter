/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2024 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_payments_repository/models/session_input.dart';
import 'package:online_payments_repository/providers/payment_product_state_provider.dart';
import 'package:online_payments_repository/providers/session_input_state_provider.dart';
import 'package:online_payments_repository/providers/session_state_provider.dart';
import 'package:online_payments_repository/models/result.dart';
import 'package:online_payments_repository/strings.dart' as strings;
import 'package:online_payments_sdk/online_payments_sdk.dart';
import 'package:online_payments_sdk_example/extensions/result_extensions.dart';
import 'package:online_payments_sdk_example/extensions/string_extensions.dart';
import 'package:online_payments_sdk_example/pages/payment_product/payment_product_page.dart';
import 'package:online_payments_sdk_example/reusable_components/default_padding.dart';
import 'package:online_payments_sdk_example/reusable_components/input_text_form_field.dart';
import 'package:online_payments_sdk_example/reusable_components/label_value_row.dart';
import 'package:online_payments_sdk_example/reusable_components/vertical_scroll_view.dart';

import '../../reusable_components/default_text.dart';
import '../../reusable_components/ok_dialog.dart';

/// This basic example only shows how to initialize a Session and how to make a Payment Product call.
/// A more extensive example - which shows the complete flow of how to create a payment - can be found at https://github.com/wl-online-payments-direct/sdk-client-flutter-example.
class InitializeSessionPage extends ConsumerWidget {
  const InitializeSessionPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const InitializeSessionPage());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();

    ref.listen(paymentProductStateProvider, (previous, next) {
      _processResult(context, next);
    });

    return VerticalScrollView(
      childWidget: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const _PaymentContextInfo(),
            DefaultPadding.all(size: 20),
            const _ClientSessionDetailsInput(),
            const DefaultPadding(),
            const _PaymentProductIdInput(),
            DefaultPadding.all(size: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  // Validate the input fields
                  if (formKey.currentState?.validate() ?? false) {
                    SessionInput sessionInput =
                        ref.read(sessionInputStateProvider);
                    ref
                        .read(sessionStateProvider.notifier)
                        .setSession(sessionInput);

                    // Execute 'getPaymentProduct' call
                    final productId =
                        ref.read(sessionInputStateProvider).paymentProductId;
                    ref
                        .read(paymentProductStateProvider.notifier)
                        .getPaymentProduct(productId);
                  }
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: const DefaultText(
                  strings.retrievePaymentProductButtonLabel,
                  textColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processResult(BuildContext context, Result<PaymentProduct> result) {
    result.process(onData: (_) {
      Navigator.push(
        context,
        PaymentProductPage.route(),
      );
    }, onErrorResponse: (errorResponse) {
      showDialog(
        context: context,
        builder: (context) => OkDialog(
          titleText: strings.apiErrorTitle,
          messageText: errorResponse.message,
        ),
      );
    }, onNativeException: (nativeException) {
      showDialog(
        context: context,
        builder: (context) => OkDialog(
          titleText: strings.nativeExceptionTitle,
          messageText: nativeException.error,
        ),
      );
    });
  }
}

class _PaymentContextInfo extends ConsumerWidget {
  const _PaymentContextInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentContext = ref.read(sessionStateProvider).paymentContext;

    return Column(
      children: [
        const DefaultText(strings.paymentContextInfo),
        LabelValueRow(
          label: strings.paymentContextAmount,
          value: paymentContext.amountOfMoney.amount.toString(),
        ),
        LabelValueRow(
          label: strings.paymentContextCurrencyCode,
          value: paymentContext.amountOfMoney.currencyCode,
        ),
        LabelValueRow(
          label: strings.paymentContextCountryCode,
          value: paymentContext.countryCode,
        ),
      ],
    );
  }
}

class _ClientSessionDetailsInput extends ConsumerWidget {
  const _ClientSessionDetailsInput();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ClientSessionIdInput(),
        DefaultPadding(),
        _CustomerIdInput(),
        DefaultPadding(),
        _ClientApiUrlInput(),
        DefaultPadding(),
        _AssetUrlInput(),
      ],
    );
  }
}

class _ClientSessionIdInput extends ConsumerWidget {
  const _ClientSessionIdInput();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InputTextFormField(
      label: strings.clientSessionIdLabel,
      tooltipText: strings.clientSessionIdTooltip,
      value: ref.watch(
        sessionInputStateProvider.select((value) => value.clientSessionId),
      ),
      onInputChanged: (value) => ref
          .read(sessionInputStateProvider.notifier)
          .updateClientSessionId(value),
      validate: (value) => value.validateNullOrEmpty(),
    );
  }
}

class _CustomerIdInput extends ConsumerWidget {
  const _CustomerIdInput();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InputTextFormField(
      label: strings.customerIdLabel,
      tooltipText: strings.customerIdTooltip,
      value: ref.watch(
        sessionInputStateProvider.select((value) => value.customerId),
      ),
      onInputChanged: (value) =>
          ref.read(sessionInputStateProvider.notifier).updateCustomerId(value),
      validate: (value) => value.validateNullOrEmpty(),
    );
  }
}

class _ClientApiUrlInput extends ConsumerWidget {
  const _ClientApiUrlInput();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InputTextFormField(
      label: strings.clientApiUrlLabel,
      tooltipText: strings.clientApiUrlTooltip,
      value: ref.watch(
        sessionInputStateProvider.select((value) => value.clientApiUrl),
      ),
      onInputChanged: (value) => ref
          .read(sessionInputStateProvider.notifier)
          .updateClientApiUrl(value),
      validate: (value) => value.validateNullOrEmpty(),
    );
  }
}

class _AssetUrlInput extends ConsumerWidget {
  const _AssetUrlInput();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InputTextFormField(
      label: strings.assetsUrlLabel,
      tooltipText: strings.assetsUrlTooltip,
      value: ref.watch(
        sessionInputStateProvider.select((value) => value.assetUrl),
      ),
      onInputChanged: (value) =>
          ref.read(sessionInputStateProvider.notifier).updateAssetUrl(value),
      validate: (value) => value.validateNullOrEmpty(),
    );
  }
}

class _PaymentProductIdInput extends ConsumerWidget {
  const _PaymentProductIdInput();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InputTextFormField(
      label: strings.paymentProductIdLabel,
      tooltipText: strings.paymentProductIdTooltip,
      value: ref.watch(
        sessionInputStateProvider.select((value) => value.paymentProductId),
      ),
      onInputChanged: (value) => ref
          .read(sessionInputStateProvider.notifier)
          .updatePaymentProductId(value),
      validate: (value) => value.validateNullOrEmpty(),
    );
  }
}
