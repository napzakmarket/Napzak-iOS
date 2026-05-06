//
//  RequestPhoneVerificationCodeUseCase.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/26.
//

import Foundation

struct RequestPhoneVerificationCodeUseCase {
    private let repository: PhoneVerificationRepository

    init(repository: PhoneVerificationRepository) {
        self.repository = repository
    }

    func execute(phoneNumber: String) async -> Result<PhoneVerificationCodeSendResult, PhoneVerificationError> {
        await repository.requestCode(for: phoneNumber)
    }
}
