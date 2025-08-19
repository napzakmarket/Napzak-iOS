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
        chatStoreInfo: ChatStoreInfo(storeId: 0, nickname: "", isWithdrawn: false, isReported: false, storePhoto: "")
    )
    @Published var chatMessages: [ChatMessageModel] = []
    @Published var messageText = ""
    @Published var roomId: Int?
    @Published var productId: Int?
    @Published var isChatDisabled: Bool = false
    @Published var isProfileNeeded: Bool = false
    @Published var isReadMyMessage: Bool = false
    @Published var shouldUpdateProductInfo = false
    @Published var selectedImage: UIImage? = nil

    //MARK: - Properties
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "ChatDetail")

    private let chatStompManager = ChatStompManager.shared
    private let chatEventManager = ChatEventManager.shared
    let loadingManager = LoadingViewManager()

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
                    await self.fetchChatMessages(roomId: roomId)
                    if !self.chatMessages.isEmpty {
                        await self.enterChatRoom(roomId: roomId)
                    }
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
                
                if let currentRoomId = roomId, data.roomId == currentRoomId {
                         
                    var messageData: ChatMessageModel

                    if data.type == .system {
                        isChatDisabled = true
                        
                        messageData = ChatMessageModel(
                            id: data.messageId,
                            senderId: data.senderId,
                            type: data.type,
                            content: nil,
                            metaData: data.metadata,
                            createdAt: data.createdAt,
                            isProfileNeeded: false,
                            isMessageOwner: false,
                            isRead: false
                        )
                        chatMessages.append(messageData)
                    }

                    guard let senderId = data.senderId else { return }
                    let isMessageOwner: Bool = chatDetailInfo.chatStoreInfo.storeId != senderId
                    
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
                    
                    isProfileNeeded = isMessageOwner
                    chatMessages.append(messageData)
                }
            }
            .store(in: &cancellables)
    }
    
    func observeChatReadStatus() {
        chatStompManager.receivedStatusDTOSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self else { return }
                
                if let roomId, data.roomId == roomId {
                    guard let senderId = data.senderId else { return }
                    let isMyStatus: Bool = self.chatDetailInfo.chatStoreInfo.storeId != senderId
                    
                    switch data.type {
                    case .join:
                        if !isMyStatus {
                            chatMessages = chatMessages.map { message in
                                var updatedMessage = message
                                updatedMessage.isRead = true
                                
                                return updatedMessage
                            }
                            isReadMyMessage = true
                        } else {
                            isReadMyMessage = false
                        }
                    case .leave:
                        isReadMyMessage = false
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchChatDetailInfo(productId: Int) async {
        loadingManager.startLoading()
        defer { loadingManager.stopLoading() }

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
            if chatDetailInfo.chatStoreInfo.isWithdrawn || chatDetailInfo.chatStoreInfo.isReported {
                isChatDisabled = true
            }
            shouldUpdateProductInfo = data.productInfo.productId != self.productId
            
        case .failure(let error):
            logger.error("getChatInfo failed: \(error.localizedDescription)")
        }
    }
    
    func fetchWebSocket() {
        chatStompManager.socketStatusSubject
            .sink { [weak self] status in
                guard let self else { return }
                
                switch status {
                case .connected:
                    self.logger.debug("✅ 연결됨")
                case .disconnected:
                    self.logger.error("❌ 연결 끊김")
                }
            }
            .store(in: &cancellables)
    }
    
    func updateProductInfo(newProductId: Int) async {
        let result = await NetworkService.shared.chatService.patchChatInfo(roomId: roomId ?? 0, requestBody: ChatInfoRequestDTO(newProductId: newProductId))
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("patchChatInfo: No data received")
                return
            }
            
            self.productId = data.updatedProductId
        case .failure(let error):
            logger.error("patchChatInfo failed: \(error.localizedDescription)")
        }

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
            chatEventManager.didUpdateChatRoomsSubject.send()
            
        case .failure(let error):
            logger.error("postCreateChatRoom failed: \(error.localizedDescription)")
        }
    }
    
    func fetchChatMessages(roomId: Int) async {
        loadingManager.startLoading()
        defer { loadingManager.stopLoading() }

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
            shouldUpdateProductInfo = data.productId != chatDetailInfo.productInfo.productId
            
        case .failure(let error):
            logger.error("patchEnterChatRoom failed: \(error.localizedDescription)")
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
    
    func sendFirstImageMessage(firstImageUrls: [String]) {
        Task {
            await sendProductMessage()
            try? await Task.sleep(nanoseconds: 500_000_000)
            await sendImageMessage(imageUrls: firstImageUrls)
        }
    }
    
    func sendProductUpdateMessage(messageText: String) {
        Task {
            await updateProductInfo(newProductId: chatDetailInfo.productInfo.productId)
            await sendProductMessage()
            try? await Task.sleep(nanoseconds: 500_000_000)
            await sendTextMessage(text: messageText)
            shouldUpdateProductInfo = false
        }
    }
    
    func sendProductUpdateImageMessage(imageUrls: [String]) {
        Task {
            await updateProductInfo(newProductId: chatDetailInfo.productInfo.productId)
            await sendProductMessage()
            try? await Task.sleep(nanoseconds: 500_000_000)
            await sendImageMessage(imageUrls: imageUrls)
            shouldUpdateProductInfo = false
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
    
    func uploadImage() async {
        if let selectedImage = selectedImage {
            let imageName = UUID().uuidString + ".jpg"
            let presignedResult = await NetworkService.shared.presignedService.getChatPresignedURL(imageNameList: [imageName])

            switch presignedResult {
            case .success(let response):
                guard let uploadURL = response.data?.chatPresignedUrls[imageName],
                      let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
                    logger.error("이미지 데이터 생성 혹은 Presigned URL 파싱 실패")
                    return
                }

                let uploadResult = await NetworkService.shared.presignedService.putPresignedURL(url: uploadURL, imageData: imageData)

                switch uploadResult {
                case .success:
                    logger.info("✅ 이미지 업로드 성공")
                    
                    let imageURL = uploadURL.components(separatedBy: "?").first ?? uploadURL
                    
                    if chatMessages.isEmpty && roomId == nil {
                        await postChatRoomCreate()
                        sendFirstImageMessage(firstImageUrls: [imageURL])
                    } else if shouldUpdateProductInfo {
                        sendProductUpdateImageMessage(imageUrls: [imageURL])
                    } else {
                        await sendImageMessage(imageUrls: [imageURL])
                    }
                                        
                case .failure(let error):
                    logger.error("❌이미지 업로드 실패: \(error.localizedDescription)")
                }

            case .failure(let error):
                logger.error("❌ Presigned URL 요청 실패: \(error.localizedDescription)")
            }
        }
    }
}
