//
//  VerificationToastType.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/25/26.
//

import Foundation

enum VerificationToastType: Equatable {
    case verificationCodeSent
    case phoneNumberAlreadyRegistered
    case phoneNumberBlocked
    case verificationCodeRequestFailed
    case verificationCodeConfirmFailed
    case networkDisconnected
    case verificationRequestLimitExceeded
}

extension VerificationToastType {
    var message: String {
        switch self {
        case .verificationCodeSent:
            return "인증번호를 보냈어요"
        case .phoneNumberAlreadyRegistered:
            return "이미 가입된 번호입니다."
        case .phoneNumberBlocked:
            return "가입을 진행할 수 없습니다. 문의사항은 고객센터로 연락해주세요."
        case .verificationCodeRequestFailed:
            return "인증번호 발송에 실패했습니다. 다시 시도해주세요."
        case .verificationCodeConfirmFailed:
            return "인증번호 확인에 실패했습니다. 다시 시도해주세요."
        case .networkDisconnected:
            return "네트워크 연결을 확인하고 다시 시도해주세요."
        case .verificationRequestLimitExceeded:
            return "오늘 인증 요청 가능 횟수를 초과했습니다. 내일 다시 시도해주세요."
        }
    }
    
    var imageName: String {
        switch self {
        case .verificationCodeSent:
            return "toast_verification_code_sent"
        case .phoneNumberAlreadyRegistered:
            return "toast_phone_number_already_registered"
        case .phoneNumberBlocked:
            return "toast_phone_number_blocked"
        case .verificationCodeRequestFailed:
            return "toast_verification_code_request_failed"
        case .verificationCodeConfirmFailed:
            return "toast_verification_code_confirm_failed"
        case .networkDisconnected:
            return "toast_network_disconnected"
        case .verificationRequestLimitExceeded:
            return "toast_verification_request_limit_exceeded"
        }
    }
}
