//
//  ChatViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/3/25.
//

import SwiftUI

import Combine
import os

@MainActor
final class ChatViewModel: ObservableObject {
    
    //MARK: - Property Wrappers

    @Published var chatRooms: [ChatRoomModel] = []
    @Published var chatRoomIds: [Int] = []

    //MARK: - Properties
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "Chat")
    
    private let chatEventManager = ChatEventManager.shared
    let loadingManager = LoadingViewManager()
    
    private var cancellables = Set<AnyCancellable>()

    //MARK: - Init

    init() {
        Task {
            await fetchChatRooms()
        }

        observeChatEvent()
    }
}

private extension ChatViewModel {
    
    //MARK: - Private Func
    
    func observeChatEvent() {
        chatEventManager.didUpdateChatRoomsSubject
            .sink { [weak self] in
                guard let self = self else { return }
                
                Task {
                    await self.fetchChatRooms()
                }
            }
            .store(in: &cancellables)
    }
}

extension ChatViewModel {
    
    //MARK: - Func

    func fetchChatRooms() async {
        loadingManager.startLoading()
        defer { loadingManager.stopLoading() }

        let result = await NetworkService.shared.chatService.getChatRooms(deviceToken: nil)
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("getChatRooms: No data received")
                return
            }
            
            chatRooms = data.chatRooms.map { ChatRoomModel(dto: $0) }
            chatRoomIds = data.chatRooms.map { $0.roomId }
            
        case .failure(let error):
            logger.error("getChatRooms failed: \(error.localizedDescription)")
        }
    }
}
