//
//  ChatRoomEnterResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/24/25.
//

typealias ChatRoomEnterResponseDTO = BaseResponseDTO<ChatRoomEnterDTO>

struct ChatRoomEnterDTO: Decodable {
    let productId: Int
    let onlineStoreIds: [Int]
}
