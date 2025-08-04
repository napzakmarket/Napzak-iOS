//
//  ChatRoomResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/28/25.
//

typealias ChatRoomResponseDTO = BaseResponseDTO<ChatRoomsDTO>

struct ChatRoomsDTO: Decodable {
    let chatRooms: [ChatRoomDTO]
}

struct ChatRoomDTO: Decodable {
    let roomId: Int
    let opponentNickname: String
    let isOpponentWithdrawn: Bool
    let lastMessage: String
    let lastMessageAt: String
    let unreadCount: Int
    let opponentStorePhoto: String
    let isMessageAllowed: Bool?
}
