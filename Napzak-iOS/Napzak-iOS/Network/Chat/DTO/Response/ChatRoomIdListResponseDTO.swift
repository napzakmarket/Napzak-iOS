//
//  ChatRoomIdListResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/28/25.
//

typealias ChatRoomIdListResponseDTO = BaseResponseDTO<ChatRoomIdListDTO>

struct ChatRoomIdListDTO: Decodable {
    let chatRoomIds: [Int]
}
