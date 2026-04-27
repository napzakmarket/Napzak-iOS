//
//  PhoneVerificationManager.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/27/26.
//

import Foundation
import os

@MainActor
final class PhoneVerificationManager: ObservableObject {
    @Published private(set) var isPhoneVerified: Bool = false

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "PhoneVerification")
    private let repository: PhoneVerificationRepository

    init(repository: PhoneVerificationRepository = DefaultPhoneVerificationRepository()) {
        self.repository = repository
    }

    func setPhoneVerified(_ isPhoneVerified: Bool) {
        self.isPhoneVerified = isPhoneVerified
    }

    func reset() {
        isPhoneVerified = false
    }

    func refreshStatus() async {
        let result = await repository.fetchStatus()

        switch result {
        case .success(let status):
            isPhoneVerified = status.isPhoneVerified

        case .failure(let error):
            logger.error("refreshStatus failed: \(error.localizedDescription)")
        }
    }
}
