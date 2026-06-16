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

import '../../domain/account_on_file/account_on_file.dart';
import '../../domain/account_on_file/account_on_file_attribute.dart';
import '../../domain/payment_product/basic_payment_product.dart';
import '../../domain/payment_product/basic_payment_products.dart';
import '../../domain/payment_product/payment_product.dart';
import '../../domain/payment_product/product_field/data_restrictions.dart';
import '../../domain/payment_product/product_field/payment_product_field.dart';
import '../../domain/payment_product/product_field/payment_product_field_type.dart';
import '../../domain/payment_product/product_field/product_field_display_hints.dart';
import '../../domain/payment_product/specific_data/payment_product_302_specific_data.dart';
import '../../domain/payment_product/specific_data/payment_product_320_specific_data.dart';
import '../api_models/account_on_file/account_on_file_attribute_dto.dart';
import '../api_models/account_on_file/account_on_file_dto.dart';
import '../api_models/payment_product/basic_payment_product_dto.dart';
import '../api_models/payment_product/basic_payment_products_dto.dart';
import '../api_models/payment_product/data_restrictions_dto.dart';
import '../api_models/payment_product/display_hints/product_field_display_hints_dto.dart';
import '../api_models/payment_product/payment_product_dto.dart';
import '../api_models/payment_product/payment_product_field_dto.dart';
import '../interfaces/payment_product_factory.dart';
import '../utils/formatter.dart';
import 'validation_rule_factory.dart';

class DefaultPaymentProductFactory implements PaymentProductFactory {
  final ValidationRuleFactory _validationRuleFactory = ValidationRuleFactory();

  @override
  BasicPaymentProducts createBasicPaymentProducts(BasicPaymentProductsDto dto) {
    final products = dto.paymentProducts.map(createBasicPaymentProduct).toList();
    return BasicPaymentProducts(products);
  }

  @override
  PaymentProduct createPaymentProduct(PaymentProductDto dto) {
    final fields = dto.fields
        .map(createPaymentProductField)
        .toList()
      ..sort();

    return PaymentProduct(
      dto.id,
      dto.paymentMethod,
      paymentProductGroup: dto.paymentProductGroup,
      allowsRecurring: dto.allowsRecurring,
      allowsTokenization: dto.allowsTokenization,
      usesRedirectionTo3rdParty: dto.usesRedirectionTo3rdParty,
      label: dto.displayHints.label,
      logo: dto.displayHints.logo,
      displayOrder: dto.displayHints.displayOrder,
      maxAmount: dto.maxAmount,
      minAmount: dto.minAmount,
      paymentProduct302SpecificData: _parse302SpecificData(dto.paymentProduct302SpecificData),
      paymentProduct320SpecificData: _parse320SpecificData(dto.paymentProduct320SpecificData),
      accountsOnFile: dto.accountsOnFile.map(createAccountOnFile).toList(),
      fields: fields,
    );
  }

  BasicPaymentProduct createBasicPaymentProduct(BasicPaymentProductDto dto) {
    return BasicPaymentProduct(
      dto.id,
      dto.paymentMethod,
      paymentProductGroup: dto.paymentProductGroup,
      allowsRecurring: dto.allowsRecurring,
      allowsTokenization: dto.allowsTokenization,
      usesRedirectionTo3rdParty: dto.usesRedirectionTo3rdParty,
      label: dto.displayHints.label,
      logo: dto.displayHints.logo,
      displayOrder: dto.displayHints.displayOrder,
      maxAmount: dto.maxAmount,
      minAmount: dto.minAmount,
      paymentProduct302SpecificData: _parse302SpecificData(dto.paymentProduct302SpecificData),
      paymentProduct320SpecificData: _parse320SpecificData(dto.paymentProduct320SpecificData),
      accountsOnFile: dto.accountsOnFile.map(createAccountOnFile).toList(),
    );
  }

  AccountOnFile createAccountOnFile(AccountOnFileDto dto) {
    final aliasAttribute = dto.attributes.where((a) => a.key == 'alias').firstOrNull;
    final alias = aliasAttribute?.value;
    final mask = dto.displayHints?.labelTemplate.where((t) => t.attributeKey == 'alias').firstOrNull?.mask;

    final label = Formatter.applyMask(mask, alias) ?? alias;

    return AccountOnFile(
      dto.id,
      dto.paymentProductId,
      label: label,
      attributes: dto.attributes.map(_createAccountOnFileAttribute).toList(),
    );
  }

  PaymentProductField createPaymentProductField(PaymentProductFieldDto dto) {
    return PaymentProductField(
      dto.id,
      _parseFieldType(dto.type),
      displayHints: _createDisplayHints(dto.displayHints),
      dataRestrictions: _createDataRestrictions(dto.dataRestrictions),
    );
  }

  ProductFieldDisplayHints _createDisplayHints(ProductFieldDisplayHintsDto? dto) {
    if (dto == null) return const ProductFieldDisplayHints.empty();
    return ProductFieldDisplayHints(
      alwaysShow: dto.alwaysShow,
      obfuscate: dto.obfuscate,
      displayOrder: dto.displayOrder,
      label: dto.label,
      placeholderLabel: dto.placeholderLabel,
      mask: dto.mask,
      preferredInputType: dto.preferredInputType,
      tooltipLabel: dto.tooltip?.label,
      formElementType: dto.formElement?.type,
    );
  }

  DataRestrictions _createDataRestrictions(DataRestrictionsDto dto) {
    return DataRestrictions(
      isRequired: dto.isRequired,
      validationRules: _validationRuleFactory.createRules(dto.validators),
    );
  }

  AccountOnFileAttribute _createAccountOnFileAttribute(AccountOnFileAttributeDto dto) {
    return AccountOnFileAttribute(
      key: dto.key,
      value: dto.value,
      status: _parseAttributeStatus(dto.status),
    );
  }

  // --- helpers ---

  PaymentProductFieldType _parseFieldType(String type) {
    switch (type.toLowerCase()) {
      case 'numericstring':
        return PaymentProductFieldType.numericString;
      case 'expirydate':
        return PaymentProductFieldType.expiryDate;
      case 'integer':
        return PaymentProductFieldType.integer;
      case 'boolean':
        return PaymentProductFieldType.boolean;
      case 'date':
        return PaymentProductFieldType.date;
      case 'tel':
        return PaymentProductFieldType.tel;
      case 'text':
        return PaymentProductFieldType.text;
      default:
        return PaymentProductFieldType.string;
    }
  }

  AccountOnFileAttributeStatus? _parseAttributeStatus(String? status) {
    switch (status) {
      case 'READ_ONLY':
        return AccountOnFileAttributeStatus.readOnly;
      case 'CAN_WRITE':
        return AccountOnFileAttributeStatus.canWrite;
      case 'MUST_WRITE':
        return AccountOnFileAttributeStatus.mustWrite;
      default:
        return null;
    }
  }

  PaymentProduct302SpecificData? _parse302SpecificData(Map<String, dynamic>? data) {
    if (data == null) return null;
    final networks = (data['networks'] as List<dynamic>?)?.cast<String>() ?? [];
    return PaymentProduct302SpecificData(networks);
  }

  PaymentProduct320SpecificData? _parse320SpecificData(Map<String, dynamic>? data) {
    if (data == null) return null;
    final networks = (data['networks'] as List<dynamic>?)?.cast<String>() ?? [];
    final gateway = data['gateway'] as String? ?? '';
    return PaymentProduct320SpecificData(networks, gateway);
  }
}
