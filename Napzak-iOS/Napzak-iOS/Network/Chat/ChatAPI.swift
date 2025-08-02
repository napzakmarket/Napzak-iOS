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
    case getChatInfo(productId: Int, roomId: Int?)
    case postCreateChatRoom(requestBody: ChatRoomCreateRequestDTO)
    case patchEnterChatRoom(roomId: Int)
    case getChatMessages(roomId: Int)
    case getChatRooms(deviceToken: String?)
    case patchLeaveChatRoom(roomId: Int)
    case patchExitChatRoom(roomId: Int)
    case getChatRoomIds
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
        case .getChatInfo(productId: let productId, _):
            return "products/chat/\(productId)"
        case .postCreateChatRoom, .getChatRooms:
            return "rooms"
        case .patchEnterChatRoom(let roomId):
            return "rooms/\(roomId)/enter"
        case .getChatMessages(let roomId):
            return "rooms/\(roomId)/messages"
        case .patchLeaveChatRoom(let roomId):
            return "rooms/\(roomId)/leave"
        case .patchExitChatRoom(let roomId):
            return "rooms/\(roomId)/exit"
        case .getChatRoomIds:
            return "rooms/ids"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchEnterChatRoom, .patchLeaveChatRoom, .patchExitChatRoom:
            return .patch
        case .postCreateChatRoom:
            return .post
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getChatInfo(_, let roomId):
            if let roomId {
                return .requestParameters(parameters: ["roomId" : roomId], encoding: URLEncoding.queryString)
            } else {
                return .requestPlain
            }
        case .postCreateChatRoom(let requestBody):
            return .requestJSONEncodable(requestBody)
        case .getChatRooms(let deviceToken):
            if let deviceToken {
                return .requestParameters(parameters: ["deviceToken" : deviceToken], encoding: URLEncoding.queryString)
            } else {
                return .requestPlain
            }
        default:
            return .requestPlain
        }
    }
}
