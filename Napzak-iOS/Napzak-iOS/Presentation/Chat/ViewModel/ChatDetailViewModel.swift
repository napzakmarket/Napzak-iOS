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
    @Published var productId: Int?
    @Published var isChatDisabled: Bool = false

    //MARK: - Properties
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "ChatDetail")

    private let chatStompManager = ChatStompManager.shared
    private let chatEventManager = ChatEventManager.shared

    private var didRecieveStompMessage = false
    
    private var didUpdateProductIdSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Init

    init(chatEntry: ChatEntry) {
        switch chatEntry {
        case .product(let productId):
            self.productId = productId
            self.roomId = nil
            
            Task {
                await fetchChatDetailInfo(productId: productId)
            }
            observeRoomId()
        case .room(let roomId):
            self.roomId = roomId
            self.productId = nil
            
            Task {
                await patchChatRoomEnter(roomId: roomId)
                await fetchChatMessages(roomId: roomId)
            }
            observeProductId()
        }
        fetchWebSocket()
        observeChatMessage()
        chatEventManager.chatStatus = .active
    }
    
    deinit {
        chatEventManager.chatStatus = .inactive
    }
}

private extension ChatDetailViewModel {
    
    //MARK: - Private Func
    
    func observeRoomId() {
        $roomId
            .sink { [weak self] roomId in
                guard let self, let roomId else { return }
                
                Task {
                    await self.patchChatRoomEnter(roomId: roomId)
                    await self.fetchChatMessages(roomId: roomId)
                }
            }
            .store(in: &cancellables)
    }
    
    func observeProductId() {
        $productId
            .sink { [weak self] productId in
                guard let self, let productId else { return }
                
                Task {
                    await self.fetchChatDetailInfo(productId: productId)
                }
            }
            .store(in: &cancellables)
    }
    
    func observeChatMessage() {
        chatStompManager.receivedMessageSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }

                self.chatMessages.append(data)
                if data.type == .system {
                    isChatDisabled = true
                }
                self.didRecieveStompMessage = true
            }
            .store(in: &cancellables)
    }
}

extension ChatDetailViewModel {
    
    //MARK: - Func

    func fetchChatDetailInfo(productId: Int) async {
        let result = await NetworkService.shared.chatService.getChatInfo(productId: productId, roomId: roomId)
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("getChatInfo: No data received")
                return
            }
            
            chatDetailInfo.productInfo = ChatProductInfo(dto: data.productInfo)
            chatDetailInfo.chatStoreInfo = ChatStoreInfo(dto: data.storeInfo)
            roomId = data.roomId ?? nil
            isChatDisabled = chatDetailInfo.chatStoreInfo.isWithdrawn
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
            chatStompManager.subscribe(roomId: data.roomId)
            chatEventManager.didUpdateChatRoomsSubject.send()
            
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
    
    func leaveChatRoom() async {
        guard let roomId else { return }
        let result = await NetworkService.shared.chatService.patchLeaveChatRoom(roomId: roomId)
        
        switch result {
        case .success:
            if didRecieveStompMessage {
                chatEventManager.didUpdateChatRoomsSubject.send()
            }
        case .failure(let error):
            logger.error("patchLeaveChatRoom failed: \(error.localizedDescription)")
        }
    }
    
    func exitChatRoom() async {
        guard let roomId else { return }
        let result = await NetworkService.shared.chatService.patchExitChatRoom(roomId: roomId)
        
        switch result {
        case .success:
            chatEventManager.didUpdateChatRoomsSubject.send()
        case .failure(let error):
            logger.error("patchLeaveChatRoom failed: \(error.localizedDescription)")
        }
    }

        
    func fetchChatMessages(roomId: Int) async {
        let result = await NetworkService.shared.chatService.getChatMessages(roomId: roomId)
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("getChatMessages: No data received")
                return
            }
            
            self.chatMessages = data.messages.reversed().map { ChatMessageModel(dto: $0) }
            if !data.messages.isEmpty && data.messages[0].type == .system {
                isChatDisabled = true
            }
        case .failure(let error):
            logger.error("getChatMessages failed: \(error.localizedDescription)")
        }
    }
    
    func fetchWebSocket() {
        chatStompManager.socketStatusSubject
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
    
    func sendFirstMessage(firstMessageText: String) {
        Task {
            await sendProductMessage()
            await sendTextMessage(text: firstMessageText)
        }
    }
    
    func sendProductMessage() async {
        guard let roomId else { return }
        
        let message = ChatMessageRequestDTO(
            roomId: roomId,
            type: .product,
            content: nil,
            metadata:
                    .product(
                        ProductMeta(
                            type: .product,
                            tradeType: chatDetailInfo.productInfo.tradeType,
                            productId: chatDetailInfo.productInfo.productId,
                            genreName: chatDetailInfo.productInfo.genreName,
                            title: chatDetailInfo.productInfo.title,
                            price: chatDetailInfo.productInfo.price
                        )
                    )
        )
        
        chatStompManager.sendChat(message: message)
    }
    
    func sendTextMessage(text: String? = nil) async {
        guard let roomId else { return }
        
        let message = ChatMessageRequestDTO(
            roomId: roomId,
            type: .text,
            content: text == nil ? messageText : text,
            metadata: nil
        )
        
        chatStompManager.sendChat(message: message)
    }

    func sendImageMessage(imageUrls: [String]) async {
        guard let roomId else { return }
        
        let imageMeta = ImageMeta(type: .image, imageUrls: imageUrls)
        let message = ChatMessageRequestDTO(
            roomId: roomId,
            type: .image,
            content: nil,
            metadata: .image(imageMeta)
        )

        chatStompManager.sendChat(message: message)
    }
}
