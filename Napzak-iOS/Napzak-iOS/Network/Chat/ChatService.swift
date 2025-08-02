//
//  ChatService.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/24/25.
//

import Foundation
import Moya

protocol ChatServiceProtocol {
    func getChatInfo(productId: Int, roomId: Int?) async -> Result<ChatDetailResponseDTO, NetworkError>
    func postCreateChatRoom(requestBody: ChatRoomCreateRequestDTO) async -> Result<ChatRoomCreateResponseDTO, NetworkError>
    func patchEnterChatRoom(roomId: Int) async -> Result<ChatRoomEnterResponseDTO, NetworkError>
    func getChatMessages(roomId: Int) async -> Result<ChatMessageResponseDTO, NetworkError>
    func getChatRooms(deviceToken: String?) async -> Result<ChatRoomResponseDTO, NetworkError>
    func patchLeaveChatRoom(roomId: Int) async -> Result<Void, NetworkError>
    func patchExitChatRoom(roomId: Int) async -> Result<Void, NetworkError>
    func getChatRoomIds() async -> Result<ChatRoomIdListResponseDTO, NetworkError>
    func getMyStoreId() async -> Result<StoreIdResponseDTO, NetworkError>
}

final class ChatService: BaseService, ChatServiceProtocol {
    
    private let provider = MoyaProvider<ChatAPI>.init(plugins: [MoyaPlugin()])
        
    func getChatInfo(productId: Int, roomId: Int?) async -> Result<ChatDetailResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getChatInfo(productId: productId, roomId: roomId))
    }
    
    func postCreateChatRoom(requestBody: ChatRoomCreateRequestDTO) async -> Result<ChatRoomCreateResponseDTO, NetworkError> {
        return await requestDecodable(provider, .postCreateChatRoom(requestBody: requestBody))
    }
    
    func patchEnterChatRoom(roomId: Int) async -> Result<ChatRoomEnterResponseDTO, NetworkError> {
        return await requestDecodable(provider, .patchEnterChatRoom(roomId: roomId))
    }
    
    func getChatMessages(roomId: Int) async -> Result<ChatMessageResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getChatMessages(roomId: roomId))
    }
    
    func getChatRooms(deviceToken: String? = nil) async -> Result<ChatRoomResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getChatRooms(deviceToken: deviceToken))
    }
    
    func patchLeaveChatRoom(roomId: Int) async -> Result<Void, NetworkError> {
        return await requestVoid(provider, .patchLeaveChatRoom(roomId: roomId))
    }
    
    func patchExitChatRoom(roomId: Int) async -> Result<Void, NetworkError> {
        return await requestVoid(provider, .patchExitChatRoom(roomId: roomId))
    }
    
    func getChatRoomIds() async -> Result<ChatRoomIdListResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getChatRoomIds)
    }
    
    func getMyStoreId() async -> Result<StoreIdResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getMyStoreId)
    }
}
