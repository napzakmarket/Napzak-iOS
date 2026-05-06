//
//  PhoneVerificationAPI.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/26.
//

import Foundation

import Moya

enum PhoneVerificationAPI {
    case fetchStatus
    case sendCode(request: PhoneVerificationSendCodeRequestDTO)
    case verifyCode(request: PhoneVerificationVerifyCodeRequestDTO)
}

extension PhoneVerificationAPI: BaseTargetType {
    var headerType: HeaderType {
        .accessTokenHeader
    }

    var path: String {
        switch self {
        case .fetchStatus:
            return "stores/phone-verification-status"
        case .sendCode:
            return "stores/phone-verifications/send"
        case .verifyCode:
            return "stores/phone-verifications/confirm"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchStatus:
            return .get
        case .sendCode, .verifyCode:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .fetchStatus:
            return .requestPlain
        case .sendCode(let request):
            return .requestJSONEncodable(request)
        case .verifyCode(let request):
            return .requestJSONEncodable(request)
        }
    }
}
