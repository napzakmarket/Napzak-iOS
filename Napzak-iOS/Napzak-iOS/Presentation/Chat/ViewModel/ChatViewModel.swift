//
//  ChatViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/3/25.
//

import SwiftUI

@MainActor
final class ChatViewModel: ObservableObject {
    
    //MARK: - Property Wrappers

    @Published var chatRooms: [ChatRoomModel] = []
    
    //MARK: - Init

    init() {
        fetchChatMessages()
    }
}

extension ChatViewModel {
    func fetchChatMessages() {
        chatRooms = ChatRoomModel.mock
    }
}
