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

import XCTest
import OnlinePaymentsKit
import Flutter
@testable import online_payments_sdk

class ValidationTests: XCTestCase {
    let displayHints: [String: Any] = [
       "displayOrder": 0,
        "mask": "{{9999}} {{9999}} {{9999}} {{9999}} {{999}}",
        "alwaysShow": false,
        "formElement": [
            "type": "text"
        ],
        "label": "Card number",
        "obfuscate": false,
        "placeholderLabel": "",
        "preferredInputType": "StringKeyboard",
        "tooltip": [
            "label": ""
        ]
    ]

    var fieldData: [String: Any] = [:];
    var fieldDataWithDataRestrictions: [String: Any] = [:];

    override func setUp() {
        super.setUp()


        fieldData = [
            "id": "cardNumber",
            "type": "numericstring",
            "dataRestrictions": [
                "isRequired": true,
                "validators": [
                    "luhn": [:],
                    "length": [
                        "minLength": 13,
                        "maxLength": 19
                    ],
                    "regularExpression": [
                        "regularExpression": "^[0-9]*$"
                    ]
                ]
            ],
            "displayHints": displayHints
        ]

        fieldDataWithDataRestrictions = [
            "id": "cardNumber",
            "type": "numericstring",
            "dataRestrictions": [
                "isRequired": true,
                "validationRules": [
                    [
                        "type": "LUHN",
                        "messageId": "luhn"
                    ],
                    [
                        "type": "LENGTH",
                        "messageId": "length",
                        "minLength": 13,
                        "maxLength": 19
                    ],
                    [
                        "type": "REGULAREXPRESSION",
                        "messageId": "regularExpression",
                        "pattern": "^[0-9]*$"
                    ]
                ]
            ],
            "displayHints": displayHints
        ]
    }

    override func tearDown() {
        super.tearDown()
    }

    func testPaymentProductFieldValidationWithValidatorsFormat() {
        let requestData: [String: Any] = [
            "value": "4000000000000002",
            "field": fieldData,
        ]
        
        // Test the validation
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestData)
            let requestString = String(data: jsonData, encoding: .utf8)!
            
            let call = FlutterMethodCall(
                methodName: "validateValueForPaymentProductField",
                arguments: ["request": requestString]
            )
            let handler = ValidatorMethodCallHandler()
            let expectation = XCTestExpectation(description: "Validation completes")
            
            handler.handle(call) { result in
                if let validationResult = result as? String {
                    if let data = validationResult.data(using: .utf8),
                       let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                        // Valid card number should have no validation errors
                        XCTAssertTrue(jsonArray.isEmpty, "Valid card number should pass validation with validators format")
                    } else {
                        XCTFail("Failed to parse validation result")
                    }
                } else if let error = result as? FlutterError {
                    XCTFail("Validation failed with Flutter error: \(error)")
                } else {
                    XCTFail("Unexpected result type: \(String(describing: result))")
                }
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
            
        } catch {
            XCTFail("Failed to create test data: \(error)")
        }
    }
    
    func testInvalidCardNumberValidation() {

        let requestData: [String: Any] = [
            "value": "1234", // Invalid: too short and fails Luhn
            "field": fieldData,
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestData)
            let requestString = String(data: jsonData, encoding: .utf8)!
            
            let call = FlutterMethodCall(
                methodName: "validateValueForPaymentProductField",
                arguments: ["request": requestString]
            )
            let handler = ValidatorMethodCallHandler()
            let expectation = XCTestExpectation(description: "Validation completes")
            
            handler.handle(call) { result in
                if let validationResult = result as? String {
                    if let data = validationResult.data(using: .utf8),
                       let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                        // Invalid card number should have validation errors
                        XCTAssertFalse(jsonArray.isEmpty, "Invalid card number should fail validation")
                    } else {
                        XCTFail("Failed to parse validation result")
                    }
                } else if let error = result as? FlutterError {
                    XCTFail("Validation failed with Flutter error: \(error)")
                } else {
                    XCTFail("Unexpected result type: \(String(describing: result))")
                }
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
            
        } catch {
            XCTFail("Failed to create test data: \(error)")
        }
    }
    
    func testValidationWithValidationRulesFormat() {
        // Test with validationRules format (Flutter style)

        let requestData: [String: Any] = [
            "value": "4000000000000002",
            "field": fieldDataWithDataRestrictions,
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestData)
            let requestString = String(data: jsonData, encoding: .utf8)!
            
            let call = FlutterMethodCall(
                methodName: "validateValueForPaymentProductField",
                arguments: ["request": requestString]
            )
            let handler = ValidatorMethodCallHandler()
            let expectation = XCTestExpectation(description: "Validation completes")
            
            handler.handle(call) { result in
                if let validationResult = result as? String {
                    if let data = validationResult.data(using: .utf8),
                       let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                        print("ValidationRules format parsed result: \(jsonArray)")
                        // This test shows whether Swift can handle validationRules format
                    } else {
                        XCTFail("Failed to parse validation result")
                    }
                } else if let error = result as? FlutterError {
                    XCTFail("Validation failed with Flutter error: \(error)")
                } else {
                    XCTFail("Unexpected result type: \(String(describing: result))")
                }
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
            
        } catch {
            XCTFail("Failed to create test data: \(error)")
        }
    }
    
    func testMixedValidationFormats() {
        // Test with both validators and validationRules to see which takes precedence
        let fieldData: [String: Any] = [
            "id": "cardNumber",
            "type": "numericstring",
            "dataRestrictions": [
                "isRequired": true,
                "validators": [
                    "luhn": [:],
                    "length": [
                        "minLength": 13,
                        "maxLength": 19
                    ]
                ],
                "validationRules": [
                    [
                        "type": "LUHN",
                        "messageId": "luhn"
                    ],
                    [
                        "type": "LENGTH",
                        "messageId": "length",
                        "minLength": 15,
                        "maxLength": 16
                    ]
                ]
            ],
            "displayHints": [
                "displayOrder": 0,
                "mask": "{{9999}} {{9999}} {{9999}} {{9999}} {{999}}",
                "alwaysShow": false,
                "formElement": [
                    "type": "text"
                ],
                "label": "Card number",
                "obfuscate": false,
                "placeholderLabel": "",
                "preferredInputType": "StringKeyboard",
                "tooltip": [
                    "label": ""
                ]
            ]
        ]
        
        let requestData: [String: Any] = [
            "value": "400000000000000", // 15 digits - valid for validationRules but not validators
            "field": fieldData,
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestData)
            let requestString = String(data: jsonData, encoding: .utf8)!
            
            let call = FlutterMethodCall(
                methodName: "validateValueForPaymentProductField",
                arguments: ["request": requestString]
            )
            let handler = ValidatorMethodCallHandler()
            let expectation = XCTestExpectation(description: "Validation completes")
            
            handler.handle(call) { result in
                if let validationResult = result as? String {
                    if let data = validationResult.data(using: .utf8),
                       let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                        XCTAssertEqual(jsonArray.count, 1)
                    } else {
                        XCTFail("Failed to parse validation result")
                    }
                } else if let error = result as? FlutterError {
                    XCTFail("Validation failed with Flutter error: \(error)")
                } else {
                    XCTFail("Unexpected result type: \(String(describing: result))")
                }
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
            
        } catch {
            XCTFail("Failed to create test data: \(error)")
        }
    }
}
