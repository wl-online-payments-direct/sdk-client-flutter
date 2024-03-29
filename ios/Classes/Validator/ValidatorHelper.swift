/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2023 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */
import OnlinePaymentsKit

struct ValidatorHelper {
    enum ValidationKeys: CodingKey {
        case value, paymentRequest, fieldId, validationType, rule
    }

    static func getRule(container: KeyedDecodingContainer<ValidatorHelper.ValidationKeys>, ruleContainer: KeyedDecodingContainer<ValidatorHelper.ValidationKeys>) -> Validator? {
        guard let typeString = try? ruleContainer.decodeIfPresent(String.self, forKey: .validationType) else {
            return decodeDefaultValidator(container: container)
        }

        switch typeString {
        case "EXPIRATIONDATE":
            return decodeValidator(validatorType: ValidatorExpirationDate.self, container: container)
        case "EMAILADDRESS":
            return decodeValidator(validatorType: ValidatorEmailAddress.self, container: container)
        case "FIXEDLIST":
            return decodeValidator(validatorType: ValidatorFixedList.self, container: container)
        case "IBAN":
            return decodeValidator(validatorType: ValidatorIBAN.self, container: container)
        case "LENGTH":
            return decodeValidator(validatorType: ValidatorLength.self, container: container)
        case "LUHN":
            return decodeValidator(validatorType: ValidatorLuhn.self, container: container)
        case "RANGE":
            return decodeValidator(validatorType: ValidatorRange.self, container: container)
        case "REGULAREXPRESSION":
            return decodeValidator(validatorType: ValidatorRegularExpression.self, container: container)
        case "TERMSANDCONDITIONS":
            return decodeValidator(validatorType: ValidatorTermsAndConditions.self, container: container)
        default:
            return decodeDefaultValidator(container: container)
        }
    }
    
    private static func decodeValidator<T: Validator>(validatorType: T.Type, container: KeyedDecodingContainer<ValidatorHelper.ValidationKeys>) -> Validator? {
        guard let decodedValidator = try? container.decode(validatorType.self, forKey: .rule) else {
            return decodeDefaultValidator(container: container)
        }
        return decodedValidator
    }
    
    private static func decodeDefaultValidator(container: KeyedDecodingContainer<ValidatorHelper.ValidationKeys>) -> Validator? {
        return try? container.decode(Validator.self, forKey: .rule)
    }
}
