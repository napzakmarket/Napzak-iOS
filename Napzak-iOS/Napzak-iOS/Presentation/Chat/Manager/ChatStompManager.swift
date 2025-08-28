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
    var receivedMyStoreIdSubject = PassthroughSubject<Int?, Never>()
    var receivedRoomIdsSubject = PassthroughSubject<[Int]?, Never>()
    
    private var chatEventManager = ChatEventManager.shared
    
    private var pingTimer: AnyCancellable?
    private var pongReceivedAt: Date?
    private let pongTimeout: TimeInterval = 30
    private var subscribedChatRoomIds: [Int]?
    private var subscribedMyStoreId: Int?
    private var isTearingDown = false
    private var reconnectCount = 0
    
    private var cancellables = Set<AnyCancellable>()
    private var eventsCancellable = Set<AnyCancellable>()
    private var messagesCancellable = Set<AnyCancellable>()
    
    private var activeDestinations = Set<String>()

    //MARK: - Life Cycle
    
    private init() {
        observeInitialIds()
    }
}

private extension ChatStompManager {
    
    //MARK: - Private Func
    
    func initializeWebSocket() {
        guard stompClient == nil else {
            if socketStatusSubject.value == .disconnected {
                connect()
            }
            return
        }
        
        switch KeychainManager.shared.getAccessToken() {
        case .success(let token):
            logger.info("WebSocket 초기화 시작...")
            accessToken = token
            
            guard let urlString = Bundle.main.infoDictionary?["WEBSOCKET_URL"] as? String,
                  let url = URL(string: urlString) else { return }
            
            stompClient = SwiftStomp(
                host: url,
                httpConnectionHeaders: ["Authorization": "Bearer \(accessToken ?? "")"]
            )
            
            stompClient?.autoReconnect = true
            subscribeStomp()
            connect()
            
        case .failure:
            logger.info("토큰이 없어 WebSocket을 초기화할 수 없습니다.")
        }
    }
    
    func observeInitialIds() {
        Publishers.CombineLatest(receivedMyStoreIdSubject, receivedRoomIdsSubject)
            .receive(on: RunLoop.main)
            .sink { [weak self] (storeId, roomIds) in
                guard let self else { return }
                
                subscribedMyStoreId = storeId
                subscribedChatRoomIds = roomIds
                
                guard let storeId, let roomIds else { return }
                self.logger.debug("📡 내 상점 ID(\(storeId)) 확보, 참여 중인 채팅방 IDs(\(roomIds)) 확보")
                initializeWebSocket()
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
                    logger.debug("✅ WebSocket 연결 완료")
                    socketStatusSubject.send(.connected)
                    stompClient?.subscribe(to: "/topic/pong")
                    startPing()
                    reconnectCount = 0

                    if let subscribedMyStoreId {
                        subscribeMyStoreChannel(storeId: subscribedMyStoreId)
                    }
                    if let subscribedChatRoomIds {
                        subscribeChatRooms(roomIds: subscribedChatRoomIds)
                    }
                case .disconnected(_):
                    logger.debug("❎ WebSocket 연결 해제")
                    stopPing()
                    activeDestinations.removeAll()
                    socketStatusSubject.send(.disconnected)
                    
                    guard !isTearingDown && reconnectCount <= 5 else { return }
                    logger.debug("🔌 WebSocket 재연결")
                    reconnectCount += 1

                    connect()
                case let .error(error):
                    logger.error("❌ WebSocket 연결 실패: \(error)")
                    stopPing()
                    activeDestinations.removeAll()
                    socketStatusSubject.send(.disconnected)
                    
                    guard !isTearingDown && reconnectCount <= 5 else { return }
                    logger.debug("🔌 WebSocket 재연결")
                    reconnectCount += 1
                    connect()
                }
            }
            .store(in: &eventsCancellable)
        
        stompClient?.messagesUpstream
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                
                switch message {
                case .text(let messageString, _, let destination, _):
                    print(messageString)
                    
                    if destination == "/queue/chat.room-created.\(subscribedMyStoreId!)" {
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
            .store(in: &messagesCancellable)
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
            .publish(every: 20, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.sendPing()
            }
    }

    func stopPing() {
        pingTimer?.cancel()
        pingTimer = nil
    }

    func sendPing() {
        guard stompClient?.isConnected == true else { return }
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
        logger.debug("✅ ping 전송")
    }

    func subscribeChatRooms(roomIds: [Int]) {
        for id in roomIds {
            subscribeChatRoom(roomId: id)
        }
    }
    
    func subscribeChatRoom(roomId: Int) {
        guard stompClient?.isConnected == true else { return }
        
        let destination = "/topic/chat.room.\(roomId)"
        guard activeDestinations.insert(destination).inserted else {
            logger.debug("⏭️ 이미 구독중: \(destination)")
            return
        }
        stompClient?.subscribe(
            to: destination,
            mode: .auto
        )
        
        logger.debug("✅ \(roomId)번 채팅방 구독")
    }
    
    func subscribeMyStoreChannel(storeId: Int) {
        guard stompClient?.isConnected == true else { return }
        
        let destination = "/queue/chat.room-created.\(storeId)"
        guard activeDestinations.insert(destination).inserted else {
            logger.debug("⏭️ 이미 구독중: \(destination)")
            return
        }
        stompClient?.subscribe(
            to: destination,
            mode: .auto
        )
        
        logger.debug("✅ \(storeId) 채널 구독")
    }
    
    func teardownSocket() {
        isTearingDown = true
        stompClient?.autoReconnect = false
        stopPing()

        if stompClient?.isConnected == true {
            unsubscribeAll()
        }
        activeDestinations.removeAll()
        eventsCancellable.removeAll()
        messagesCancellable.removeAll()

        if stompClient?.isConnected == true {
            stompClient?.disconnect()
        }

        stompClient = nil
        accessToken = nil
        receivedMyStoreIdSubject.send(nil)
        receivedRoomIdsSubject.send(nil)
        socketStatusSubject.send(.disconnected)
        
        isTearingDown = false
        logger.debug("🔚 WebSocket 정상 종료")
    }

    private func unsubscribeAll() {
        for destination in activeDestinations {
            stompClient?.unsubscribe(from: destination)
        }
    }
}

extension ChatStompManager {
    func connect() {
        guard stompClient?.isConnected == false else { return }
        stompClient?.connect()
    }

    func disconnect() {
        guard stompClient?.isConnected == true else { return }
        teardownSocket()
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
