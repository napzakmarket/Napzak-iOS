//
//  ChatDetailViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/30/25.
//

import SwiftUI

@MainActor
final class ChatDetailViewModel: ObservableObject {
    
    //MARK: - Property Wrappers

    @Published var chatDetailInfo = ChatDetailModel(
        productInfo: ChatProductInfo(productId: 0, photo: "", tradeType: .buy, title: "", price: 0, isPriceNegotiable: false, genreName: ""),
        chatStoreInfo: ChatStoreInfo(storeId: 0, nickname: "", isWithdrawn: false, storePhoto: "")
    )
    @Published var chatMessages: [ChatMessageModel] = []
    @Published var messageText = ""
    
    //MARK: - Init

    init() {
        fetchChatDetailInfo()
        fetchChatMessages()
    }
}

extension ChatDetailViewModel {
    func fetchChatDetailInfo() {
        chatDetailInfo = ChatDetailModel.mock
    }
    
    func fetchChatMessages() {
        chatMessages = ChatMessageModel.mock
    }
}
