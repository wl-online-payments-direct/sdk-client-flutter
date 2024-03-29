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
import Foundation
import Flutter
import OnlinePaymentsKit

internal class SdkBridge {
    static private let TAG = "SdkBridge"
    static let shared = SdkBridge()
    private init() {}
    private var session: Session?

    func isSessionInitialized() -> Bool {
        return session != nil
    }

    func initializeSession(
        request: InitializeSessionRequest
    ) {
        self.session =
            Session(
                clientSessionId: request.clientSessionId,
                customerId: request.customerId,
                baseURL: request.clientApiUrl,
                assetBaseURL: request.assetUrl,
                appIdentifier: request.appIdentifier,
                loggingEnabled: request.loggingEnabled
            )
    }

    func getPublicKey(result: @escaping FlutterResult) {
        session?.publicKey(
            success: { publicKeyResponse in
                self.forwardSuccessResult(object: PublicKeyResponse.self, dataObject: publicKeyResponse, result: result)
            },
            failure: { error in
                self.forwardFailureResult(object: PublicKeyResponse.self, throwable: Throwable(message: error.localizedDescription), result: result)
            },
            apiFailure: { errorResponse in
                self.forwardApiFailureResult(object: PublicKeyResponse.self, errorResponse: errorResponse, result: result)
            }
        ) ?? result(ResultError.sessionNotInitialized())
    }

    func getIinDetails(request: IinDetailsRequest, result: @escaping FlutterResult) {
        session?.iinDetails(
            forPartialCreditCardNumber: request.partialCreditCardNumber,
            context: request.paymentContext,
            success: { iiNDetailsResponse in
                self.forwardSuccessResult(object: IINDetailsResponse.self, dataObject: iiNDetailsResponse, result: result)
            },
            failure: { error in
                self.forwardFailureResult(object: IINDetailsResponse.self, throwable: Throwable(message: error.localizedDescription), result: result)
            },
            apiFailure: { errorResponse in
                self.forwardApiFailureResult(object: IINDetailsResponse.self, errorResponse: errorResponse, result: result)
            }
        ) ?? result(ResultError.sessionNotInitialized())
    }

    func getBasicPaymentProducts(request: BasicPaymentProductsRequest, result: @escaping FlutterResult) {
        session?.paymentProducts(
            for: request.paymentContext,
            success: { basicPaymentProducts in
                self.forwardSuccessResult(object: BasicPaymentProducts.self, dataObject: basicPaymentProducts, result: result)
            },
            failure: { error in
                self.forwardFailureResult(object: BasicPaymentProducts.self, throwable: Throwable(message: error.localizedDescription), result: result)
            },
            apiFailure: { errorResponse in
                self.forwardApiFailureResult(object: BasicPaymentProducts.self, errorResponse: errorResponse, result: result)
            }
        ) ?? result(ResultError.sessionNotInitialized())
    }

    func getPaymentProduct(request: PaymentProductRequest, result: @escaping FlutterResult) {
        session?.paymentProduct(
            withId: request.productId,
            context: request.paymentContext,
            success: { paymentProduct in
                self.forwardSuccessResult(object: PaymentProduct.self, dataObject: paymentProduct, result: result)
            },
            failure: { error in
                self.forwardFailureResult(object: PaymentProduct.self, throwable: Throwable(message: error.localizedDescription), result: result)
            },
            apiFailure: { errorResponse in
                self.forwardApiFailureResult(object: PaymentProduct.self, errorResponse: errorResponse, result: result)
            }
        ) ?? result(ResultError.sessionNotInitialized())
    }

    func getPaymentProductNetworks(request: PaymentProductNetworksRequest, result: @escaping FlutterResult) {
        session?.paymentProductNetworks(
            forProductId: request.productId,
            context: request.paymentContext,
            success: { paymentProductNetworks in
                self.forwardSuccessResult(object: PaymentProductNetworks.self, dataObject: paymentProductNetworks, result: result)
            },
            failure: { error in
                self.forwardFailureResult(object: PaymentProductNetworks.self, throwable: Throwable(message: error.localizedDescription), result: result)
            },
            apiFailure: { errorResponse in
                self.forwardApiFailureResult(object: PaymentProductNetworks.self, errorResponse: errorResponse, result: result)
            }
        ) ?? result(ResultError.sessionNotInitialized())
    }

    func getCurrencyConversionWithPartialCCNumber(request: CurrencyConversionRequest, result: @escaping FlutterResult) {
            guard let partialCreditCardNumber = request.partialCreditCardNumber else {
                result(ResultError.invalidParameter(parameter: "partialCreditCardNumber"))
                return
            }

            session?.currencyConversionQuote(
                amountOfMoney: request.amountOfMoney,
                partialCreditCardNumber: partialCreditCardNumber,
                paymentProductId: request.paymentProductId as NSNumber?,
                success: { currencyConversionResponse in
                    self.forwardSuccessResult(object: CurrencyConversionResponse.self, dataObject: currencyConversionResponse, result: result)
                },
                failure: { error in
                    self.forwardFailureResult(object: CurrencyConversionResponse.self, throwable: Throwable(message: error.localizedDescription), result: result)
                },
                apiFailure: { errorResponse in
                    self.forwardApiFailureResult(object: CurrencyConversionResponse.self, errorResponse: errorResponse, result: result)
                }
            ) ?? result(ResultError.sessionNotInitialized())
        }

        func getCurrencyConversionWithToken(request: CurrencyConversionRequest, result: @escaping FlutterResult) {
            guard let token = request.token else {
                result(ResultError.invalidParameter(parameter: "token"))
                return
            }

            session?.currencyConversionQuote(
                amountOfMoney: request.amountOfMoney,
                token: token,
                success: { currencyConversionResponse in
                    self.forwardSuccessResult(object: CurrencyConversionResponse.self, dataObject: currencyConversionResponse, result: result)
                },
                failure: { error in
                    self.forwardFailureResult(object: CurrencyConversionResponse.self, throwable: Throwable(message: error.localizedDescription), result: result)
                },
                apiFailure: { errorResponse in
                    self.forwardApiFailureResult(object: CurrencyConversionResponse.self, errorResponse: errorResponse, result: result)
                }
            ) ?? result(ResultError.sessionNotInitialized())
        }

    func getSurchargeCalculationWithPartialCCNumber(request: SurchargeCalculationRequest, result: @escaping FlutterResult) {
        guard let partialCreditCardNumber = request.partialCreditCardNumber else {
            result(ResultError.invalidParameter(parameter: "partialCreditCardNumber"))
            return
        }

        session?.surchargeCalculation(
            amountOfMoney: request.amountOfMoney,
            partialCreditCardNumber: partialCreditCardNumber,
            paymentProductId: request.paymentProductId as NSNumber?,
            success: { surchargeCalculationResponse in
                self.forwardSuccessResult(object: SurchargeCalculationResponse.self, dataObject: surchargeCalculationResponse, result: result)
            },
            failure: { error in
                self.forwardFailureResult(object: SurchargeCalculationResponse.self, throwable: Throwable(message: error.localizedDescription), result: result)
            },
            apiFailure: { errorResponse in
                self.forwardApiFailureResult(object: SurchargeCalculationResponse.self, errorResponse: errorResponse, result: result)
            }
        ) ?? result(ResultError.sessionNotInitialized())
    }

    func getSurchargeCalculationWithToken(request: SurchargeCalculationRequest, result: @escaping FlutterResult) {
        guard let token = request.token else {
            result(ResultError.invalidParameter(parameter: "token"))
            return
        }

        session?.surchargeCalculation(
            amountOfMoney: request.amountOfMoney,
            token: token,
            success: { surchargeCalculationResponse in
                self.forwardSuccessResult(object: SurchargeCalculationResponse.self, dataObject: surchargeCalculationResponse, result: result)
            },
            failure: { error in
                self.forwardFailureResult(object: SurchargeCalculationResponse.self, throwable: Throwable(message: error.localizedDescription), result: result)
            },
            apiFailure: { errorResponse in
                self.forwardApiFailureResult(object: SurchargeCalculationResponse.self, errorResponse: errorResponse, result: result)
            }
        ) ?? result(ResultError.sessionNotInitialized())
    }

    func preparePaymentRequest(request: PreparePaymentRequest, result: @escaping FlutterResult) {
        session?.prepare(
            request.paymentRequest,
            success: { preparedPaymentRequest in
                self.forwardSuccessResult(object: PreparedPaymentRequest.self, dataObject: preparedPaymentRequest, result: result)
            },
            failure: { error in
                self.forwardFailureResult(object: PreparedPaymentRequest.self, throwable: Throwable(message: error.localizedDescription), result: result)
            },
            apiFailure: { errorResponse in
                self.forwardApiFailureResult(object: PreparedPaymentRequest.self, errorResponse: errorResponse, result: result)
            }
        ) ?? result(ResultError.sessionNotInitialized())
    }

    private func forwardSuccessResult<T: Encodable>(object: T.Type, dataObject: T, result: @escaping FlutterResult) {
        let sdkResult = Result<T>(data: dataObject, error: nil, throwable: nil)
        sdkResult.forwardResultAsString(encodingErrorType: .success, result: result)
    }

    private func forwardFailureResult<T: Encodable>(object: T.Type, throwable: Throwable, result: @escaping FlutterResult) {
        let sdkResult = Result<T>(data: nil, error: nil, throwable: throwable)
        sdkResult.forwardResultAsString(encodingErrorType: .failure, result: result)
    }

    private func forwardApiFailureResult<T: Encodable>(object: T.Type, errorResponse: ErrorResponse, result: @escaping FlutterResult) {
        let sdkResult = Result<T>(data: nil, error: errorResponse, throwable: nil)
        sdkResult.forwardResultAsString(encodingErrorType: .apiFailure, result: result)
    }
}
