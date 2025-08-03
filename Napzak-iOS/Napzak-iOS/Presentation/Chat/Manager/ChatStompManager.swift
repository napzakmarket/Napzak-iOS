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

final class ChatStompManager: ObservableObject {
    
    //MARK: - Properties
    
    static let shared = ChatStompManager()
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "ChatStomp")

    private var stompClient: SwiftStomp?
    private var accessToken: String?
    
    var socketStatusSubject = CurrentValueSubject<SocketStatus, Never>(.disconnected)
    var receivedMessageDTOSubject = PassthroughSubject<WebSocketRedeivedChatMessageDTO, Never>()
    var receivedStatusDTOSubject = PassthroughSubject<WebSocketRedeivedChatStatusDTO, Never>()
    var receivedRoomIdsSubject = PassthroughSubject<[Int], Never>()
    var receivedMyStoreIdSubject = PassthroughSubject<Int, Never>()
    
    private var chatEventManager = ChatEventManager.shared
    
    private var pingTimer: AnyCancellable?
    private var pongReceivedAt: Date?
    private let pongTimeout: TimeInterval = 30
    private var subscribedChatRoomIds: [Int] = []
    private var subscribedMyStoreId: Int = 0
    
    private var cancellables = Set<AnyCancellable>()

    //MARK: - Life Cycle
    
    private init() {
        observeSubscribedChatRoomIds()
        observeSubscribedMyStoreId()
        
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
            connect()
            subscribeStomp()
        case .failure:
            logger.info("No accessToken found in Keychain at startup")
        }
    }
}

private extension ChatStompManager {
    
    //MARK: - Private Func
    
    func observeSubscribedChatRoomIds() {
        receivedRoomIdsSubject
            .sink { [weak self] roomIds in
                guard let self else { return }
                
                self.subscribedChatRoomIds =  roomIds
            }
            .store(in: &cancellables)
    }
    
    func observeSubscribedMyStoreId() {
        receivedMyStoreIdSubject
            .sink { [weak self] storeId in
                guard let self else { return }
                
                self.subscribedMyStoreId = storeId
            }
            .store(in: &cancellables)
    }
    
    func subscribeStomp() {
        stompClient?.eventsUpstream
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .connected(_):
                    socketStatusSubject.send(.connected)
                    logger.debug("✅ WebSocket 연결 완료")
                    startPing()

                    stompClient?.subscribe(to: "/topic/pong")
                    subscribeChatRooms(roomIds: subscribedChatRoomIds)
                    if !subscribedChatRoomIds.contains(subscribedMyStoreId) {
                        subscribeMyStoreChannel(storeId: subscribedMyStoreId)
                    }
                case .disconnected(_):
                    logger.debug("❎ WebSocket 연결 해제")
                    socketStatusSubject.send(.disconnected)
                    stopPing()
                case let .error(error):
                    logger.error("❌ WebSocket 연결 실패: \(error)")
                    socketStatusSubject.send(.disconnected)
                }
            }
            .store(in: &cancellables)
        
        stompClient?.messagesUpstream
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                
                switch message {
                case .text(let messageString, _, let destination, _):
                    if destination == "/queue/chat.room-created.\(subscribedMyStoreId)" {
                        logger.debug("💬 생성된 채팅방 ID: \(messageString)")
                        if let roomId = Int(messageString) {
                            subscribeChatRoom(roomId: roomId)
                        }
                        chatEventManager.didUpdateChatRoomsSubject.send()
                    } else {
                        if chatEventManager.chatStatus == .inactive {
                            chatEventManager.didUpdateChatRoomsSubject.send()
                        }
                        
                        if let jsonData = messageString.data(using: .utf8) {
                            do {
                                let chatMessage = try JSONDecoder().decode(WebSocketRedeivedChatMessageDTO.self, from: jsonData)
                                receivedMessageDTOSubject.send(chatMessage)
                            } catch {
                                do {
                                    let statusData = try JSONDecoder().decode(WebSocketRedeivedChatStatusDTO.self, from: jsonData)
                                    
                                    receivedStatusDTOSubject.send(statusData)
                                } catch {
                                    logger.error("JSON 디코딩 오류: \(error)")
                                }
                            }
                        }
                    }
                    
                case .data:
                    logger.debug("📥 하트비트 수신, 연결 정상")
                }
            }
            .store(in: &cancellables)
    }
    
//    당장은 활용x 추후 활용 가능성 있음
//    func monitorPong() {
//        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] timer in
//            guard let self else { return }
//            
//            if let last = pongReceivedAt {
//                let elapsed = Date().timeIntervalSince(last)
//                if elapsed > pongTimeout {
//                    print("⚠️ Pong 응답 지연, 재연결 시도")
//                    stompClient?.disconnect()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        self.stompClient?.connect()
//                    }
//                }
//            }
//        }
//    }
    
    func startPing() {
        pingTimer = Timer
            .publish(every: 30, on: .main, in: .common) //30초 간격으로 Ping 전송
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.logger.debug("✅ ping 전송")
                self.sendPing()
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
            logger.error("❌ JSON String으로 변환 실패")
            return
        }

        stompClient?.send(body: requestBody, to: destination)
    }

    func subscribeChatRooms(roomIds: [Int]) {
        for id in roomIds {
            subscribeChatRoom(roomId: id)
        }
    }
    
    func subscribeChatRoom(roomId: Int) {
        let destination = "/topic/chat.room.\(roomId)"
        stompClient?.subscribe(
            to: destination,
            mode: .auto
        )
        
        logger.debug("✅ \(roomId)번 채팅방 구독")
    }
    
    func subscribeMyStoreChannel(storeId: Int) {
        let destination = "/queue/chat.room-created.\(storeId)"
        stompClient?.subscribe(
            to: destination,
            mode: .auto
        )
        
        logger.debug("✅ \(storeId) 채널 구독")
    }
}

extension ChatStompManager {
    func connect() {
        if !(stompClient?.isConnected ?? Bool()) {
            stompClient?.connect()
        }
    }

    func disconnect() {
        if stompClient?.isConnected ?? Bool() {
            stompClient?.disconnect()
        }
    }
    
    func subscribe(roomId: Int) {
        let destination = "/topic/chat.room.\(roomId)"
        stompClient?.subscribe(
            to: destination,
            mode: .auto
        )
        
        logger.debug("✅ \(roomId)번 채팅방 구독")
    }
    
    func sendChat(message: ChatMessageRequestDTO) {
        let destination = "/pub/chat/send"
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(message),
              let requestBody = String(data: data, encoding: .utf8) else {
            logger.error("❌ JSON 인코딩 실패")
            return
        }
        
        stompClient?.send(body: requestBody, to: destination, headers: ["content-type": "application/json"])
        logger.debug("✉️ 메시지 전송: \(requestBody)")
    }
}
