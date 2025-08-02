//
//  ChatMessageResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/28/25.
//

typealias ChatMessageResponseDTO = BaseResponseDTO<ChatMessagesDTO>

struct ChatMessagesDTO: Decodable {
    let messages: [ChatMessageNormalDTO]
}

struct ChatMessageNormalDTO: Codable {
    let messageId: Int
    let senderId: Int?
    let type: ChatMessageType
    let content: String?
    let metadata: ChatMetaDataType?
    let createdAt: String
    let isProfileNeeded: Bool
    let isMessageOwner: Bool
    let isRead: Bool
}

struct WebSocketRedeivedChatMessageDTO: Codable {
    let messageId: Int
    let roomId: Int
    let senderId: Int?
    let type: ChatMessageType
    let content: String?
    let metadata: ChatMetaDataType?
    let createdAt: String
    let isRead: Bool
}
