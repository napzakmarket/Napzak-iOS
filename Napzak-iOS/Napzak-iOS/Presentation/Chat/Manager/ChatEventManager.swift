//
//  ChatEventManager.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/28/25.
//

import Combine

enum ChatStatus {
    case active
    case inactive
}

final class ChatEventManager {
    static let shared = ChatEventManager()
    
    private init() {}

    let didUpdateChatRoomsSubject = PassthroughSubject<Void, Never>()
    var chatStatus: ChatStatus = .inactive
}
