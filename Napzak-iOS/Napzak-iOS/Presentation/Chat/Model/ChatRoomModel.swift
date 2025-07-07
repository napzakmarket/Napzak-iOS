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
}

extension ChatRoomModel {
    static let mock: [ChatRoomModel] = [
        ChatRoomModel(
            id: 0,
            opponentNickname: "납자기",
            isOpponentWithdrawn: false,
            lastMessage: "(이미지)",
            lastMessageAt: "오전 1:38",
            unreadCount: 8,
            opponentStorePhoto: ""
        ),
        ChatRoomModel(
            id: 1,
            opponentNickname: "우사기",
            isOpponentWithdrawn: false,
            lastMessage: "사용자가 채팅방을 나갔습니다.",
            lastMessageAt: "오전 1:38",
            unreadCount: 0,
            opponentStorePhoto: ""
        ),
        ChatRoomModel(
            id: 2,
            opponentNickname: "(탈퇴한 사용자) 마이린",
            isOpponentWithdrawn: true,
            lastMessage: "저기요?",
            lastMessageAt: "오전 1:38",
            unreadCount: 1000,
            opponentStorePhoto: ""
        ),
        ChatRoomModel(
            id: 3,
            opponentNickname: "정재현",
            isOpponentWithdrawn: false,
            lastMessage: "구매?",
            lastMessageAt: "오전 1:38",
            unreadCount: 11,
            opponentStorePhoto: ""
        ),
        ChatRoomModel(
            id: 4,
            opponentNickname: "토도로키",
            isOpponentWithdrawn: false,
            lastMessage: "사용자가 채팅방을 나갔습니다.",
            lastMessageAt: "오전 1:38",
            unreadCount: 8,
            opponentStorePhoto: ""
        ),
        ChatRoomModel(
            id: 5,
            opponentNickname: "납작아요",
            isOpponentWithdrawn: false,
            lastMessage: "안녕하세요~ 안녕하세요~ 안녕하세요~ 안녕하세요~ 안녕하세요~",
            lastMessageAt: "오전 1:38",
            unreadCount: 8,
            opponentStorePhoto: ""
        ),
        ChatRoomModel(
            id: 6,
            opponentNickname: "박명수",
            isOpponentWithdrawn: false,
            lastMessage: ".",
            lastMessageAt: "오전 1:38",
            unreadCount: 333,
            opponentStorePhoto: "https://i.pinimg.com/736x/86/e8/c9/86e8c92b974b7d21a84a2af1b2650143.jpg"
        )
    ]
}
