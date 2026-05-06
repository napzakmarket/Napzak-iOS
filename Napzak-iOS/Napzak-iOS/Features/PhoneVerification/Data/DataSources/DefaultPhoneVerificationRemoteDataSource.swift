//
//  DefaultPhoneVerificationRemoteDataSource.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/26.
//

import Foundation

struct DefaultPhoneVerificationRemoteDataSource: PhoneVerificationRemoteDataSource {
    private let service: PhoneVerificationServiceProtocol

    init(service: PhoneVerificationServiceProtocol = NetworkService.shared.phoneVerificationService) {
        self.service = service
    }

    func fetchStatus() async -> Result<PhoneVerificationStatusResponseDTO, NetworkError> {
        await service.fetchStatus()
    }

    func sendCode(phoneNumber: String) async -> Result<PhoneVerificationSendCodeResponseDTO, NetworkError> {
        await service.sendCode(
            request: PhoneVerificationSendCodeRequestDTO(phoneNumber: phoneNumber)
        )
    }

    func verifyCode(phoneNumber: String, code: String) async -> Result<PhoneVerificationVerifyCodeResponseDTO, NetworkError> {
        await service.verifyCode(
            request: PhoneVerificationVerifyCodeRequestDTO(
                phoneNumber: phoneNumber,
                code: code
            )
        )
    }
}
