//
//  ChatAPI.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/24/25.
//

import Foundation
import Moya

enum BaseURLType {
    case defaultUrl
    case chatUrl
}

enum ChatAPI {
    case getChatInfo(productId: Int)
    case postCreateChatRoom(requestBody: ChatRoomCreateRequestDTO)
    case patchEnterChatRoom(roomId: Int)
}

extension ChatAPI: BaseTargetType {
    var baseURLType: BaseURLType {
        switch self {
        case .getChatInfo:
            return .defaultUrl
        default:
            return .chatUrl
        }
    }
    
    var baseURL: URL {
        let urlString: String?

        switch baseURLType {
        case .defaultUrl:
            urlString = Bundle.main.infoDictionary?["BASE_URL"] as? String
        case .chatUrl:
            urlString = Bundle.main.infoDictionary?["CHAT_BASE_URL"] as? String
        }
        
        guard let urlString, let url = URL(string: urlString) else {
            fatalError("🚨Base URL을 찾을 수 없습니다🚨")
        }
        
        return url
    }

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
        case .postCreateChatRoom:
            return "rooms"
        case .patchEnterChatRoom(let roomId):
            return "rooms/\(roomId)/enter"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchEnterChatRoom:
            return .patch
        case .postCreateChatRoom:
            return .post
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postCreateChatRoom(let requestBody):
            return .requestJSONEncodable(requestBody)
        default:
            return .requestPlain
        }
    }
}
