import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';

import 'merchant_backend.dart';
import 'ui_placeholders.dart';

// [START pending-payment-store]
// Remembers the order that waits for its result while the customer is on the 3-D Secure page.
// Persist it (for example with shared_preferences), because the system can stop the app meanwhile.
// Store only the order id: never card data or session data.
abstract class PendingPaymentStore {
  Future<String?> readOrderId();
  Future<void> saveOrderId(String orderId);
  Future<void> clear();
}
// [END pending-payment-store]

// [START handle-payment-result]
Future<void> handlePaymentResult(
  MerchantPaymentResponse result, {
  required String orderId,
  required PendingPaymentStore pendingPayments,
}) async {
  final redirectUrl = result.redirectUrl;
  if (redirectUrl != null) {
    // For example 3-D Secure or a third-party payment page. Open the URL exactly as received:
    // do not build or change it. Your backend sets the payment's returnUrl to a deep link of
    // this app, so the customer comes back to the app afterwards.
    await pendingPayments.saveOrderId(orderId);
    final opened = await launchUrl(Uri.parse(redirectUrl), mode: LaunchMode.externalApplication);
    if (!opened) {
      await pendingPayments.clear();
      showStatusUnknown(); // the payment exists; let the customer check the order later
    }
    return;
  }

  // The status comes from your backend. The app never decides that a payment succeeded.
  showPaymentOutcome(result.status);
}
// [END handle-payment-result]

// [START handle-return-deep-link]
// Start once at the root of the app (in main() or the initState() of your root widget), not in the
// checkout screen: the customer can come back while another screen is shown, or the app can start
// on another screen. Cancel the subscription when the app closes. returnUrlPrefix is the start of the
// returnUrl your backend sets, for example 'myshop://payment-return'.
StreamSubscription<Uri> listenForPaymentReturn(
  AppLinks appLinks,
  String returnUrlPrefix,
  PendingPaymentStore pendingPayments,
) {
  return appLinks.uriLinkStream.listen((uri) {
    unawaited(_onReturnLink(uri, returnUrlPrefix, pendingPayments));
  });
}

Future<void> _onReturnLink(Uri uri, String returnUrlPrefix, PendingPaymentStore pendingPayments) async {
  if (!uri.toString().startsWith(returnUrlPrefix)) {
    return;
  }

  // Act only when a payment waits for its result. The same link can be delivered more than once,
  // for example as the initial link and as a stream event.
  final orderId = await pendingPayments.readOrderId();
  if (orderId == null) {
    return;
  }
  await pendingPayments.clear();

  // Do not read the outcome from the URL: ask your backend for the status.
  try {
    final result = await fetchPaymentStatus(orderId);
    showPaymentOutcome(result.status);
  } catch (_) {
    showStatusUnknown(); // the outcome is unknown, not failed: let the customer check the order later
  }
}
// [END handle-return-deep-link]

// [START handle-return-cold-start]
// If the system stopped the app while the customer was on the 3-D Secure page, the deep link
// starts the app again. Check the link that started the app once, at start-up, at the root of the
// app (next to listenForPaymentReturn), not in the checkout screen.
// _onReturnLink only acts when a payment is waiting for its result, so an old start link is ignored.
Future<void> checkPaymentReturnOnStart(
  AppLinks appLinks,
  String returnUrlPrefix,
  PendingPaymentStore pendingPayments,
) async {
  final initialLink = await appLinks.getInitialLink();
  if (initialLink != null) {
    await _onReturnLink(initialLink, returnUrlPrefix, pendingPayments);
  }
}
// [END handle-return-cold-start]
