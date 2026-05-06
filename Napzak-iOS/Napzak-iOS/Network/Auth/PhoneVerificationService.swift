//
//  PhoneVerificationService.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/26.
//

import Foundation

import Moya

protocol PhoneVerificationServiceProtocol {
    func fetchStatus() async -> Result<PhoneVerificationStatusResponseDTO, NetworkError>
    func sendCode(request: PhoneVerificationSendCodeRequestDTO) async -> Result<PhoneVerificationSendCodeResponseDTO, NetworkError>
    func verifyCode(request: PhoneVerificationVerifyCodeRequestDTO) async -> Result<PhoneVerificationVerifyCodeResponseDTO, NetworkError>
}

final class PhoneVerificationService: BaseService, PhoneVerificationServiceProtocol {
    private let provider = MoyaProvider<PhoneVerificationAPI>(plugins: [MoyaPlugin()])

    func fetchStatus() async -> Result<PhoneVerificationStatusResponseDTO, NetworkError> {
        await requestDecodable(provider, .fetchStatus)
    }

    func sendCode(request: PhoneVerificationSendCodeRequestDTO) async -> Result<PhoneVerificationSendCodeResponseDTO, NetworkError> {
        await requestDecodable(provider, .sendCode(request: request))
    }

    func verifyCode(request: PhoneVerificationVerifyCodeRequestDTO) async -> Result<PhoneVerificationVerifyCodeResponseDTO, NetworkError> {
        await requestDecodable(provider, .verifyCode(request: request))
    }
}
