//
//  ChatRoomModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/3/25.
//

struct ChatRoomModel: Identifiable {
    let id: Int
    let opponentNickname: String
    let isOpponentWithdrawn: Bool
    let lastMessage: String
    let lastMessageAt: String
    let unreadCount: Int
    let opponentStorePhoto: String
    let isMessageAllowed: Bool? = nil

    ///default init
    init(id: Int, opponentNickname: String, isOpponentWithdrawn: Bool, lastMessage: String, lastMessageAt: String, unreadCount: Int, opponentStorePhoto: String) {
        self.id = id
        self.opponentNickname = opponentNickname
        self.isOpponentWithdrawn = isOpponentWithdrawn
        self.lastMessage = lastMessage
        self.lastMessageAt = lastMessageAt
        self.unreadCount = unreadCount
        self.opponentStorePhoto = opponentStorePhoto
    }
    
    ///init for decoding
    init(dto: ChatRoomDTO) {
        self.id = dto.roomId
        self.opponentNickname = dto.opponentNickname
        self.isOpponentWithdrawn = dto.isOpponentWithdrawn
        self.lastMessage = dto.lastMessage
        self.lastMessageAt = dto.lastMessageAt
        self.unreadCount = dto.unreadCount
        self.opponentStorePhoto = dto.opponentStorePhoto
    }
}
