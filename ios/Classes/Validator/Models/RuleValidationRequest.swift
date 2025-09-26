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
import OnlinePaymentsKit

struct RuleValidationRequest: ValidationRequest {
    let value: String
    private(set) var rule: Validator?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ValidatorHelper.ValidationKeys.self)
        value = try container.decode(String.self, forKey: .value)

        guard let ruleContainer = try? container.nestedContainer(keyedBy: ValidatorHelper.ValidationKeys.self, forKey: .rule),
              let decodedRule = ValidatorHelper.getRule(container: container, ruleContainer: ruleContainer) else {
            return
        }

        rule = decodedRule
    }

    func validate() -> [ValidationError] {
        guard let rule,
            let validationRule = rule as? ValidationRule else {
            return [
                ValidationError(errorMessage: "Validator does not conform to the ValidationRule protocol", paymentProductFieldId: "Validation without paymentProductFieldId", rule: rule)
            ]
        }

        return validationRule.validate(value: value) ? [] : [ValidationError(errorMessage: rule.messageId, paymentProductFieldId: "Validation without paymentProductFieldId", rule: rule)]
    }
}
