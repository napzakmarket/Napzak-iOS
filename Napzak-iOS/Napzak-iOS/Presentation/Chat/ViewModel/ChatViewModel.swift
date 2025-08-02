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
    
    //MARK: - Properties
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "Chat")
    
    private let chatEventManager = ChatEventManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Init

    init() {
        Task {
            await fetchChatMessages()
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
                    await self.fetchChatMessages()
                }
            }
            .store(in: &cancellables)
    }
}

extension ChatViewModel {
    func fetchChatMessages() async {
        let result = await NetworkService.shared.chatService.getChatRooms(deviceToken: nil)
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("getChatRooms: No data received")
                return
            }
            
            self.chatRooms = data.chatRooms.map { ChatRoomModel(dto: $0) }
            
        case .failure(let error):
            logger.error("getChatRooms failed: \(error.localizedDescription)")
        }
    }
}
