//
//  ChatMessageRequestDTO.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/27/25.
//

struct ChatMessageRequestDTO: Encodable {
    let roomId: Int
    let type: ChatMessageType
    let content: String?
    let metadata: ChatMetaDataType?
}
