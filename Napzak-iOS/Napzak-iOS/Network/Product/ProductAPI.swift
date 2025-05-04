//
//  ProductAPI.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Moya

enum ProductAPI {
    case sellRegister(registerItem: SellRegisterRequestDTO)
    case buyRegister(registerItem: BuyRegisterRequestDTO)
}

extension ProductAPI: BaseTargetType {
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
        case .sellRegister(let registerItem):
            return .requestJSONEncodable(registerItem)
        case .buyRegister(let registerItem):
            return .requestJSONEncodable(registerItem)
        }
    }
}
