//
//  ChatDetailViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/30/25.
//

import SwiftUI

import Combine

@MainActor
final class ChatDetailViewModel: ObservableObject {
    
    //MARK: - Property Wrappers

    @Published var chatDetailInfo = ChatDetailModel(
        productInfo: ChatProductInfo(productId: 0, photo: "", tradeType: .buy, title: "", price: 0, isPriceNegotiable: false, genreName: ""),
        chatStoreInfo: ChatStoreInfo(storeId: 0, nickname: "", isWithdrawn: false, storePhoto: "")
    )
    @Published var chatMessages: [ChatMessageModel] = []
    @Published var messageText = ""
    
    //MARK: - Properties
    
    private let chatStompManager = ChatStompManager.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Init

    init() {
        fetchChatDetailInfo()
        fetchChatMessages()
        fetchWebSocket()
    }
}

extension ChatDetailViewModel {
    func fetchChatDetailInfo() {
        chatDetailInfo = ChatDetailModel.mock
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
    
    func fetchChatMessages() {
        chatMessages = ChatMessageModel.mock
    }
}
