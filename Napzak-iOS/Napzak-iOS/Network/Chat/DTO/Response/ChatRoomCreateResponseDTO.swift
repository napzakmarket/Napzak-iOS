//
//  ChatRoomCreateResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/24/25.
//

typealias ChatRoomCreateResponseDTO = BaseResponseDTO<ChatRoomCreateDTO>

struct ChatRoomCreateDTO: Decodable {
    let roomId: Int
}
