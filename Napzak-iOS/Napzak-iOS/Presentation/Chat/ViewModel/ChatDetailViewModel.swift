//
//  ChatDetailViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/30/25.
//

import SwiftUI

import Combine
import os

@MainActor
final class ChatDetailViewModel: ObservableObject {
    
    //MARK: - Property Wrappers

    @Published var chatDetailInfo = ChatDetailModel(
        productInfo: ChatProductInfo(productId: 0, photo: "", tradeType: .buy, title: "", price: 0, isPriceNegotiable: false, genreName: ""),
        chatStoreInfo: ChatStoreInfo(storeId: 0, nickname: "", isWithdrawn: false, storePhoto: ""),
        roomId: nil
    )
    @Published var chatMessages: [ChatMessageModel] = []
    @Published var messageText = ""
    
    //MARK: - Properties
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "ChatDetail")
    private let productId: Int

    private let chatStompManager = ChatStompManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Init

    init(productId: Int) {
        self.productId = productId

        fetchChatMessages()
        fetchWebSocket()
        
        Task {
            await fetchChatDetailInfo(productId: productId)
        }
    }
}

extension ChatDetailViewModel {
    func fetchChatDetailInfo(productId: Int) async {
        
        let result = await NetworkService.shared.chatService.getChatInfo(productId: productId)
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("getChatInfo: No data received")
                return
            }
            
            self.chatDetailInfo.productInfo = ChatProductInfo(dto: data.productInfo)
            self.chatDetailInfo.chatStoreInfo = ChatStoreInfo(dto: data.storeInfo)
            self.chatDetailInfo.roomId = data.roomId ?? Int()
            
        case .failure(let error):
            logger.error("getChatInfo failed: \(error.localizedDescription)")
        }
    }
        
    func fetchChatMessages() {
        chatMessages = ChatMessageModel.mock
    }
    
    func fetchWebSocket() {
        chatStompManager.socketStatus
            .sink { status in
                switch status {
                case .connected:
                    print("✅ 연결됨")
                case .disconnected:
                    print("❌ 연결 끊김")
                }
            }
            .store(in: &cancellables)
    }
}
