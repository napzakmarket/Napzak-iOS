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
}

final class ChatService: BaseService, ChatServiceProtocol {
    
    private let provider = MoyaProvider<ChatAPI>.init(plugins: [MoyaPlugin()])
        
    func getChatInfo(productId: Int) async -> Result<ChatDetailResponseDTO, NetworkError> {
        return await requestDecodable(provider, .getChatInfo(productId: productId))
    }
}
