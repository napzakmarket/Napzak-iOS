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
}

extension RegisterAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .sellRegister(let registerItem):
            return .accessTokenHeader
        }
    }

    var path: String {
        switch self {
        case .sellRegister:
            return "products/sell"
        }
    }

    var method: Moya.Method {
        switch self {
        case .sellRegister(let registerItem):
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .sellRegister:
            return .requestPlain
        }
    }

}
