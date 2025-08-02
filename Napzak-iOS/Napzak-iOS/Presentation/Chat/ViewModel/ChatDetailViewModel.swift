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
        productInfo: ChatProductInfo(productId: 0, photo: "", tradeType: .buy, title: "", price: 0, isPriceNegotiable: false, genreName: "", productOwnerId: 0, isMyProduct: false),
        chatStoreInfo: ChatStoreInfo(storeId: 0, nickname: "", isWithdrawn: false, storePhoto: "")
    )
    @Published var chatMessages: [ChatMessageModel] = []
    @Published var messageText = ""
    @Published var roomId: Int?
    @Published var productId: Int?
    @Published var isChatDisabled: Bool = false
    @Published var isProfileNeeded: Bool = false
    @Published var isReadMyMessage: Bool = false

    //MARK: - Properties
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "ChatDetail")

    private let chatStompManager = ChatStompManager.shared
    private let chatEventManager = ChatEventManager.shared
    
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
                await enterChatRoom(roomId: roomId)
                await fetchChatMessages(roomId: roomId)
            }
            observeProductId()
        }
        fetchWebSocket()
        observeChatMessage()
        observeChatReadStatus()
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
                    await self.enterChatRoom(roomId: roomId)
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
        chatStompManager.receivedMessageDTOSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }

                var messageData: ChatMessageModel
                let isMessageOwner: Bool = {
                    guard let senderId = data.senderId else { return false }
                    
                    let ownerId = self.chatDetailInfo.productInfo.productOwnerId
                    return self.chatDetailInfo.productInfo.isMyProduct ? senderId == ownerId : senderId != ownerId
                }()
                
                switch data.type {
                case .text:
                    messageData = ChatMessageModel(
                        id: data.messageId,
                        senderId: data.senderId,
                        type: data.type,
                        content: data.content,
                        metaData: nil,
                        createdAt: data.createdAt,
                        isProfileNeeded: !isMessageOwner && isProfileNeeded,
                        isMessageOwner: isMessageOwner,
                        isRead: isReadMyMessage
                    )
                default:
                    messageData = ChatMessageModel(
                        id: data.messageId,
                        senderId: data.senderId,
                        type: data.type,
                        content: nil,
                        metaData: data.metadata,
                        createdAt: data.createdAt,
                        isProfileNeeded: !isMessageOwner && isProfileNeeded,
                        isMessageOwner: isMessageOwner,
                        isRead: isReadMyMessage
                    )
                }
                
                self.chatMessages.append(messageData)

                isProfileNeeded = isMessageOwner
                
                if data.type == .system {
                    isChatDisabled = true
                }
            }
            .store(in: &cancellables)
    }
    
    func observeChatReadStatus() {
        chatStompManager.receivedStatusDTOSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }
                
                switch data.type {
                case .join:
                    chatMessages = chatMessages.map { message in
                        var updatedMessage = message
                        updatedMessage.isRead = true
                        
                        return updatedMessage
                    }
                    isReadMyMessage = true
                case .leave:
                    isReadMyMessage = false
                }
            }
            .store(in: &cancellables)
    }
    
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
    
    func enterChatRoom(roomId: Int) async {
        let result = await NetworkService.shared.chatService.patchEnterChatRoom(roomId: roomId)
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("patchEnterChatRoom: No data received")
                return
            }
            
            self.productId = data.productId
            isReadMyMessage = !data.onlineStoreIds.isEmpty
            
        case .failure(let error):
            logger.error("patchEnterChatRoom failed: \(error.localizedDescription)")
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
            } else if !data.messages.isEmpty && data.messages[0].isMessageOwner {
                isProfileNeeded = true
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
}

extension ChatDetailViewModel {
    
    //MARK: - Func
    
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
        
    func leaveChatRoom() async {
        guard let roomId else { return }
        let result = await NetworkService.shared.chatService.patchLeaveChatRoom(roomId: roomId)
        
        switch result {
        case .success:
            chatEventManager.didUpdateChatRoomsSubject.send()
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

    func sendFirstMessage(firstMessageText: String) {
        Task {
            await sendProductMessage()
            try? await Task.sleep(nanoseconds: 500_000_000)
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
    
    func sendTextMessage(text: String) async {
        guard let roomId else { return }
        
        let message = ChatMessageRequestDTO(
            roomId: roomId,
            type: .text,
            content: text,
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
