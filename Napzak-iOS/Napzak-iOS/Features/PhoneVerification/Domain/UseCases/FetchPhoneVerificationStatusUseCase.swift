//
//  FetchPhoneVerificationStatusUseCase.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/26.
//

import Foundation

struct FetchPhoneVerificationStatusUseCase {
    private let repository: PhoneVerificationRepository

    init(repository: PhoneVerificationRepository) {
        self.repository = repository
    }

    func execute() async -> Result<PhoneVerificationStatus, PhoneVerificationError> {
        await repository.fetchStatus()
    }
}
