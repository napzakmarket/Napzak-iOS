//
//  PhoneVerificationCodeVerificationResult.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/26.
//

import Foundation

struct PhoneVerificationCodeVerificationResult: Equatable {
    let isCodeMatched: Bool
    let remainingRequestCount: Int
}
