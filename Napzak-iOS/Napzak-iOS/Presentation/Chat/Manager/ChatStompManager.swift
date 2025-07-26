//
//  ChatStompManager.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 7/19/25.
//

import Foundation

import Combine
import os
import SwiftStomp

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

    private var pingTimer: AnyCancellable?
    private var pongReceivedAt: Date?
    private let pongTimeout: TimeInterval = 30
    
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
                    startPing()
                case .disconnected(_):
                    print("❎ WebSocket 연결 해제")
                    socketStatus.send(.disconnected)
                    stopPing()
                case let .error(error):
                    print("❌ WebSocket 연결 실패")
                    print(error)
                    socketStatus.send(.disconnected)
                }
            }
            .store(in: &cancellables)
        
        stompClient?.messagesUpstream
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self else { return }
                
                print("✅ pong 수신됨")
                
                pongReceivedAt = Date()
            }
            .store(in: &cancellables)
    }
    
    func monitorPong() {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] timer in
            guard let self else { return }
            
            if let last = pongReceivedAt {
                let elapsed = Date().timeIntervalSince(last)
                if elapsed > pongTimeout {
                    print("⚠️ Pong 응답 지연, 재연결 시도")
                    stompClient?.disconnect()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.stompClient?.connect()
                    }
                }
            }
        }
    }
    
    func startPing() {
        pingTimer = Timer
            .publish(every: 30, on: .main, in: .common) //30초 간격으로 Ping 전송
            .autoconnect()
            .sink { [weak self] _ in
                print("✅ ping 전송")
                self?.sendPing()
            }
    }

    func stopPing() {
        pingTimer?.cancel()
        pingTimer = nil
    }

    func sendPing() {
        let destination = "/pub/ping"

        let payload: [String: Any] = [
            "type": "PING",
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]

        guard let data = try? JSONSerialization.data(withJSONObject: payload),
              let requestBody = String(data: data, encoding: .utf8) else {
            print("❌ JSON String으로 변환 실패")
            return
        }

        stompClient?.send(body: requestBody, to: destination)
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

    func subscribe(roomId: Int) {
        stompClient?.subscribe(to: "/topic/pong")
        
        let destination = "/topic/chat.room.\(roomId)"
        stompClient?.subscribe(
            to: destination,
            mode: .client
        )
        
        print("✅ \(roomId)번 채팅방 구독")
    }
}
