//
//  ChatMessageModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/30/25.
//

struct ChatMessageModel: Identifiable {
    let id: Int
    let senderId: Int?
    let type: ChatMessageType
    let content: String?
    let metadata: ChatMetaDataType?
    let createdAt: String
    let isProfileNeeded: Bool
    let isMessageOwner: Bool
    let isRead: Bool
    
    ///default init
    init(id: Int, senderId: Int?, type: ChatMessageType, content: String?, metaData: ChatMetaDataType?, createdAt: String, isProfileNeeded: Bool, isMessageOwner: Bool, isRead: Bool) {
        self.id = id
        self.senderId = senderId
        self.type = type
        self.content = content
        self.metadata = metaData
        self.createdAt = createdAt
        self.isProfileNeeded = isProfileNeeded
        self.isMessageOwner = isMessageOwner
        self.isRead = isRead
    }
    
    ///init for decoding
    init(dto: ChatMessageNormalDTO) {
        self.id = dto.messageId
        self.senderId = dto.senderId
        self.type = dto.type
        self.content = dto.content
        self.metadata = dto.metadata
        self.createdAt = dto.createdAt
        self.isProfileNeeded = dto.isProfileNeeded
        self.isMessageOwner = dto.isMessageOwner
        self.isRead = dto.isRead
    }
}
