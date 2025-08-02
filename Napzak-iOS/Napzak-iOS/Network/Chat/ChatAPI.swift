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
    case getMyStoreId
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
        case .getChatInfo(productId: let productId, _):
            return "products/chat/\(productId)"
        case .postCreateChatRoom, .getChatRooms:
            return "chat/rooms"
        case .patchEnterChatRoom(let roomId):
            return "chat/rooms/\(roomId)/enter"
        case .getChatMessages(let roomId):
            return "chat/rooms/\(roomId)/messages"
        case .patchLeaveChatRoom(let roomId):
            return "chat/rooms/\(roomId)/leave"
        case .patchExitChatRoom(let roomId):
            return "chat/rooms/\(roomId)/exit"
        case .getChatRoomIds:
            return "chat/rooms/ids"
        case .getMyStoreId:
            return "stores/store-id"
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
