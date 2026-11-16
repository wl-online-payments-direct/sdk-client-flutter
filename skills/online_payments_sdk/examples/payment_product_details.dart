import 'package:online_payments_sdk/online_payments_sdk.dart';

// [START get-payment-product]
class SelectedProduct {
  final PaymentProduct paymentProduct;
  final AccountOnFile? accountOnFile;

  SelectedProduct(this.paymentProduct, this.accountOnFile);
}

Future<SelectedProduct> loadSelectedProduct(
  OnlinePaymentSdk sdk,
  PaymentContext paymentContext, {
  required int paymentProductId, // for a stored card: accountOnFile.paymentProductId
  String? accountOnFileId,
}) async {
  final paymentProduct = await sdk.getPaymentProduct(paymentProductId, paymentContext);
  final accountOnFile = accountOnFileId != null ? paymentProduct.getAccountOnFile(accountOnFileId) : null;

  return SelectedProduct(paymentProduct, accountOnFile);
}
// [END get-payment-product]

// [START describe-form-fields]
// Named FieldSpec, not FormField, to avoid a clash with Flutter's FormField widget.
class FieldSpec {
  final String id;
  final String label;
  final String? placeholder;
  final bool required;
  final bool obfuscate; // render with obscureText: true
  final PaymentProductFieldType type; // for example to choose the keyboardType
  final String? prefilledValue; // the stored value of the account on file, for example a masked card number
  final bool readOnly;

  FieldSpec({
    required this.id,
    required this.label,
    required this.placeholder,
    required this.required,
    required this.obfuscate,
    required this.type,
    required this.prefilledValue,
    required this.readOnly,
  });
}

// Build the form from the fields the API returns. Do not hard-code fields, masks or
// validation rules: they differ per payment product and per merchant configuration.
List<FieldSpec> describeFormFields(PaymentProduct paymentProduct, AccountOnFile? accountOnFile) {
  final fields = [...paymentProduct.fields]..sort((a, b) => a.getDisplayOrder().compareTo(b.getDisplayOrder()));

  return fields
      .map((field) => FieldSpec(
            id: field.id,
            label: field.getLabel(),
            placeholder: field.getPlaceholder(),
            required: field.isRequired(),
            obfuscate: field.shouldObfuscate(),
            type: field.type,
            prefilledValue: accountOnFile?.getValue(field.id),
            readOnly: accountOnFile != null && !accountOnFile.isWritable(field.id),
          ))
      .toList();
}
// [END describe-form-fields]
