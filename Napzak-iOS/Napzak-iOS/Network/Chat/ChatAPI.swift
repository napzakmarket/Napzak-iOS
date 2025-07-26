//
//  ChatAPI.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/24/25.
//

import Moya

enum ChatAPI {
    case getChatInfo(productId: Int)
}

extension ChatAPI: BaseTargetType {

    var headerType: HeaderType {
        switch self {
        default:
            return .accessTokenHeader
        }
    }
    
    var path: String {
        switch self {
        case .getChatInfo(let productId):
            return "products/chat/\(productId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getChatInfo:
            return .requestPlain
        }
    }
}
