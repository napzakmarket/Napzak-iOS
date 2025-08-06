//
//  ActiveChatState.swift
//  Napzak-iOS
//
//  Created by 조호근 on 8/4/25.
//

import Combine

@MainActor
final class ActiveChatState: ObservableObject {
    @Published var activeRoomID: String?
}
