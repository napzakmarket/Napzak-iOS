//
//  PhoneVerificationError.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/26.
//

import Foundation

enum PhoneVerificationError: LocalizedError, Equatable {
    case alreadyRegisteredPhoneNumber
    case alreadyVerifiedMember
    case blockedPhoneNumber
    case requestLimitExceeded
    case expiredOrMissingSession
    case tooManyVerificationAttempts
    case unauthorized
    case networkDisconnected
    case invalidRequest(String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .alreadyRegisteredPhoneNumber:
            return "이미 가입된 번호입니다."
        case .alreadyVerifiedMember:
            return "이미 번호 인증이 완료된 회원입니다."
        case .blockedPhoneNumber:
            return "가입을 진행할 수 없습니다. 문의사항은 고객센터로 연락해주세요."
        case .requestLimitExceeded:
            return "오늘 인증번호 요청 가능 횟수를 초과했습니다."
        case .expiredOrMissingSession:
            return "인증번호가 만료되었거나 존재하지 않습니다. 다시 요청해주세요."
        case .tooManyVerificationAttempts:
            return "인증번호를 여러 번 잘못 입력하셨습니다. 인증번호를 재요청해주세요."
        case .unauthorized:
            return "유효한 토큰이 필요합니다."
        case .networkDisconnected:
            return "네트워크 연결에 실패했습니다."
        case .invalidRequest(let message), .unknown(let message):
            return message
        }
    }
}
