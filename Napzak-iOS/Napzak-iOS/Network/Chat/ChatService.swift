//
//  ChatService.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/24/25.
//

import Foundation
import Moya

protocol ChatServiceProtocol {
    func getChatInfo(productId: Int) async -> Result<ChatDetailResponseDTO, NetworkError>
    func postCreateChatRoom(requestBody: ChatRoomCreateRequestDTO) async -> Result<ChatRoomCreateResponseDTO, NetworkError>
    func patchEnterChatRoom(roomId: Int) async -> Result<ChatRoomEnterResponseDTO, NetworkError>
}

final class ChatService: BaseService, ChatServiceProtocol {
    
    private let provider = MoyaProvider<ChatAPI>.init(plugins: [MoyaPlugin()])
        
    func getChatInfo(productId: Int) async -> Result<ChatDetailResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getChatInfo(productId: productId))
    }
    
    func postCreateChatRoom(requestBody: ChatRoomCreateRequestDTO) async -> Result<ChatRoomCreateResponseDTO, NetworkError> {
        return await requestDecodable(provider, .postCreateChatRoom(requestBody: requestBody))
    }
    
    func patchEnterChatRoom(roomId: Int) async -> Result<ChatRoomEnterResponseDTO, NetworkError> {
        return await requestDecodable(provider, .patchEnterChatRoom(roomId: roomId))
    }
}
