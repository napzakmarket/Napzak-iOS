//
//  VerifyPhoneVerificationCodeUseCase.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/26.
//

import Foundation

struct VerifyPhoneVerificationCodeUseCase {
    private let repository: PhoneVerificationRepository

    init(repository: PhoneVerificationRepository) {
        self.repository = repository
    }

    func execute(code: String, phoneNumber: String) async -> Result<PhoneVerificationCodeVerificationResult, PhoneVerificationError> {
        await repository.verifyCode(code, phoneNumber: phoneNumber)
    }
}
