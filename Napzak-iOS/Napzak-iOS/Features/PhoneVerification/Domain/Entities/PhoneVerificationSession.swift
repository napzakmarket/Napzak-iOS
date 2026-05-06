//
//  PhoneVerificationSession.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/26.
//

import Foundation

struct PhoneVerificationSession: Equatable {
    let name: String
    let phoneNumber: String
    let verificationCode: String
    let isCodeSent: Bool
    let isVerified: Bool
    let isAgeConfirmed: Bool

    static let empty = PhoneVerificationSession(
        name: "",
        phoneNumber: "",
        verificationCode: "",
        isCodeSent: false,
        isVerified: false,
        isAgeConfirmed: false
    )

    func copy(
        name: String? = nil,
        phoneNumber: String? = nil,
        verificationCode: String? = nil,
        isCodeSent: Bool? = nil,
        isVerified: Bool? = nil,
        isAgeConfirmed: Bool? = nil
    ) -> PhoneVerificationSession {
        PhoneVerificationSession(
            name: name ?? self.name,
            phoneNumber: phoneNumber ?? self.phoneNumber,
            verificationCode: verificationCode ?? self.verificationCode,
            isCodeSent: isCodeSent ?? self.isCodeSent,
            isVerified: isVerified ?? self.isVerified,
            isAgeConfirmed: isAgeConfirmed ?? self.isAgeConfirmed
        )
    }
}
