//
//  ChatStompManager.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/19/25.
//

import Foundation

import Combine
import SwiftStomp
import os

enum SocketStatus {
    case connected
    case disconnected
}

final class ChatStompManager {
    
    //MARK: - Properties
    
    static let shared = ChatStompManager()
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "ChatStomp")

    private var stompClient: SwiftStomp?
    private var accessToken: String?
    
    var socketStatus = CurrentValueSubject<SocketStatus, Never>(.disconnected)
    var onMessageReceived = PassthroughSubject<ChatMessageModel, Never>()

    private var cancellables = Set<AnyCancellable>()

    //MARK: - Life Cycle
    
    init() {
        switch KeychainManager.shared.getAccessToken() {
        case .success(let token):
            logger.info("Existing accessToken in Keychain: \(token, privacy: .private)")
            
            self.accessToken = token
            
            guard let urlString = Bundle.main.infoDictionary?["WEBSOCKET_URL"] as? String,
                  let url = URL(string: urlString) else { return }
            
            stompClient = SwiftStomp(
                host: url,
                httpConnectionHeaders: ["Authorization": "Bearer \(accessToken ?? "")"]
            )
            
            stompClient?.autoReconnect = true
            stompClient?.connect()
            subscribeStomp()
            
        case .failure:
            logger.info("No accessToken found in Keychain at startup")
        }
    }
}

private extension ChatStompManager {
    
    //MARK: - Private Func
    
    func subscribeStomp() {
        stompClient?.eventsUpstream
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .connected(_):
                    socketStatus.send(.connected)
                    print("✅ WebSocket 연결 완료")
                case .disconnected(_):
                    socketStatus.send(.disconnected)
                case let .error(error):
                    print("❌ WebSocket 연결 실패")
                    print(error)
                    socketStatus.send(.disconnected)
                }
            }
            .store(in: &cancellables)
    }
}

extension ChatStompManager {
    func connect() {
        if !(stompClient?.isConnected ?? Bool()) {
            socketStatus.send(.connected)
            stompClient?.connect()
        }
    }

    func disconnect() {
        if stompClient?.isConnected ?? Bool() {
            stompClient?.disconnect()
            socketStatus.send(.disconnected)
        }
    }

    func subscribe(roomId: String) {
        let destination = "/topic/chat.room.\(roomId)"
        stompClient?.subscribe(
            to: destination,
            mode: .client
        )
    }
}
