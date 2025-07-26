//
//  ChatDetailViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/30/25.
//

import SwiftUI

import Combine
import os

enum ChatEntry: Hashable {
    case product(id: Int)
    case room(id: Int)
}

@MainActor
final class ChatDetailViewModel: ObservableObject {
    
    //MARK: - Property Wrappers

    @Published var chatDetailInfo = ChatDetailModel(
        productInfo: ChatProductInfo(productId: 0, photo: "", tradeType: .buy, title: "", price: 0, isPriceNegotiable: false, genreName: ""),
        chatStoreInfo: ChatStoreInfo(storeId: 0, nickname: "", isWithdrawn: false, storePhoto: "")
    )
    @Published var chatMessages: [ChatMessageModel] = []
    @Published var messageText = ""
    @Published var roomId: Int?
    
    //MARK: - Properties
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "ChatDetail")
    var productId: Int?

    private let chatStompManager = ChatStompManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Init

    init(chatEntry: ChatEntry) {
        switch chatEntry {
        case .product(let productId):
            self.productId = productId
            self.roomId = nil
        case .room(let roomId):
            self.roomId = roomId
            self.productId = nil
        }

        fetchWebSocket()
        observeRoomId()
    }
}

private extension ChatDetailViewModel {
    func observeRoomId() {
        $roomId
            .compactMap { $0 }
            .sink { [weak self] roomId in
                Task {
                    await self?.patchChatRoomEnter(roomId: roomId)
                }
            }
            .store(in: &cancellables)
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
            self.roomId = data.roomId ?? nil
            
        case .failure(let error):
            logger.error("getChatInfo failed: \(error.localizedDescription)")
        }
    }
    
    func postChatRoomCreate() async {
        let requestBody = ChatRoomCreateRequestDTO(
            productId: chatDetailInfo.productInfo.productId,
            receiverId: chatDetailInfo.chatStoreInfo.storeId
        )
        
        let result = await NetworkService.shared.chatService.postCreateChatRoom(requestBody: requestBody)
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("postCreateChatRoom: No data received")
                return
            }
            
            self.roomId = data.roomId
            
        case .failure(let error):
            logger.error("postCreateChatRoom failed: \(error.localizedDescription)")
        }
    }
    
    func patchChatRoomEnter(roomId: Int) async {
        let result = await NetworkService.shared.chatService.patchEnterChatRoom(roomId: roomId)
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("patchEnterChatRoom: No data received")
                return
            }
            
            self.productId = data.productId
            
        case .failure(let error):
            logger.error("patchEnterChatRoom failed: \(error.localizedDescription)")
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
