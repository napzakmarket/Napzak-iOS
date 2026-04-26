//
//  VerificationToastType.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/25/26.
//

import Foundation

enum VerificationToastType: Equatable {
    case verificationCodeSent
    case invalidName
    case invalidPhoneNumber
    case phoneNumberAlreadyRegistered
    case phoneNumberBlocked
    case verificationCodeRequestFailed
    case invalidVerificationCode
    case verificationCodeConfirmFailed
    case verificationCodeExpired
    case networkDisconnected
    case verificationRequestLimitExceeded
    case tooManyVerificationAttempts
}

extension VerificationToastType {
    var message: String {
        switch self {
        case .verificationCodeSent:
            return "인증 번호를 보냈어요."
        case .invalidName:
            return "유효하지 않은 이름이에요. 실명을 입력해주세요."
        case .invalidPhoneNumber:
            return "올바른 휴대폰 번호를 입력해 주세요."
        case .phoneNumberAlreadyRegistered:
            return "이미 가입된 번호입니다."
        case .phoneNumberBlocked:
            return "가입을 진행할 수 없습니다.\n문의사항은 고객센터로 연락해주세요."
        case .verificationCodeRequestFailed:
            return "인증번호 발송에 실패했습니다. 다시 시도해주세요."
        case .invalidVerificationCode:
            return "인증번호가 올바르지 않습니다. 다시 확인해주세요."
        case .verificationCodeConfirmFailed:
            return "인증번호 확인에 실패했습니다. 다시 시도해주세요."
        case .verificationCodeExpired:
            return "인증 시간이 만료되었습니다.\n인증 번호를 다시 요청해주세요."
        case .networkDisconnected:
            return "네트워크 연결을 확인하고 다시 시도해 주세요."
        case .verificationRequestLimitExceeded:
            return "오늘 인증 요청 가능 횟수를 초과했습니다.\n내일 다시 시도해주세요."
        case .tooManyVerificationAttempts:
            return "인증번호를 여러 번 잘못 입력했습니다.\n재전송 요청해주세요."
        }
    }
    
    var imageName: String {
        switch self {
        case .verificationCodeSent:
            return "img_phone_verification_code_sent"
        case .invalidName:
            return "img_phone_verification_invalid_name"
        case .invalidPhoneNumber:
            return "img_phone_verification_invalid_phone_number"
        case .phoneNumberAlreadyRegistered:
            return "img_phone_verification_phone_number_already_registered"
        case .phoneNumberBlocked:
            return "img_phone_verification_phone_number_blocked"
        case .verificationCodeRequestFailed:
            return "img_phone_verification_code_request_failed"
        case .invalidVerificationCode:
            return "img_phone_verification_invalid_code"
        case .verificationCodeConfirmFailed:
            return "img_phone_verification_code_confirm_failed"
        case .verificationCodeExpired:
            return "img_phone_verification_code_expired"
        case .networkDisconnected:
            return "img_phone_verification_network_disconnected"
        case .verificationRequestLimitExceeded:
            return "img_phone_verification_request_limit_exceeded"
        case .tooManyVerificationAttempts:
            return "img_phone_verification_too_many_attempts"
        }
    }
}
