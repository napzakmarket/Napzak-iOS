//
//  RegisterAPI.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/5/25.
//

import Foundation

import Moya

enum RegisterAPI {
    case sellRegister(registerItem: SellRegisterRequestDTO)
    case buyRegister(registerItem: BuyRegisterRequestDTO)
}

extension RegisterAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .sellRegister:
            return .accessTokenHeader
        case .buyRegister:
            return .accessTokenHeader
        }
    }

    var path: String {
        switch self {
        case .sellRegister:
            return "products/sell"
        case .buyRegister:
            return "products/buy"
        }
    }

    var method: Moya.Method {
        switch self {
        case .sellRegister:
            return .post
        case .buyRegister:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .sellRegister:
            return .requestPlain
        case .buyRegister:
            return .requestPlain
        }
    }

}
