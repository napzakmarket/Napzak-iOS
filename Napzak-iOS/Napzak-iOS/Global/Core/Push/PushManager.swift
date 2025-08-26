//
//  PushManager.swift
//  Napzak-iOS
//
//  Created by 조호근 on 7/8/25.
//

import UserNotifications
import FirebaseMessaging
import Combine
import os

@MainActor
final class PushManager: NSObject, ObservableObject {
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "PushManager")
    
    // MARK: - Property Wrapper
    
    @Published private(set) var currentFCMToken: String?
    @Published private var chatRoomIds: [Int] = []
    
    // MARK: - Properties
    
    let permission: PushPermissionManager
    private let pushService = NetworkService.shared.pushService
    
    weak var tabRouter: TabRouter?
    weak var navigationRouter: NavigationRouter?
    var activeChatState: ActiveChatState?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(permission: PushPermissionManager) {
        self.permission = permission
        super.init()
        
        observePushToggle()
    }
    
    // MARK: - Func
    
    func configureNotifications() async {
        guard await permission.requestNotificationPermission() else { return }
    }
    
    func upsertTokenIfNeeded() async {
        guard let token = currentFCMToken else { return }
        guard AuthManager.shared.isAuthenticated else { return }
        
        let request = PushTokenRequestDTO(
            deviceToken: token,
            isEnabled:   permission.isOSPushEnabled,
            allowMessage: permission.isAppPushEnabled
        )
        Task { await pushService.upsertToken(request: request) }
    }
    
    func removeToken() async {
        guard let token = currentFCMToken else {
            logger.info("FCM 토큰이 없어 삭제 생략")
            return
        }
        
        let result = await pushService.deleteToken(fcmToken: token)
        switch result {
        case .success:
            logger.info("서버에서 FCM 토큰 삭제 성공")
        case .failure(let error):
            logger.error("서버에서 FCM 토큰 삭제 실패: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private Func
    
    private func observePushToggle() {
        permission.$isAppPushEnabled
            .dropFirst()
            .sink { [weak self] newValue in
                guard let fcmToken = self?.currentFCMToken else { return }
                 Task {
                     await self?.pushService.updatePushSetting(fcmToken: fcmToken, isEnabled: newValue)
                 }
            }
            .store(in: &cancellables)
    }
    
    
    private func extractRoomID(from userInfo: [AnyHashable: Any]) -> String? {
        if let roomIdString = userInfo["roomId"] as? String {
            return roomIdString
        } else if let roomIdInt = userInfo["roomId"] as? Int {
            return String(roomIdInt)
        }
        return nil
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension PushManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        
        guard permission.shouldShowPush else {
            logger.info("앱/OS 알림꺼짐 -> 알림 무시")
            return []
        }
        
        let userInfo = notification.request.content.userInfo
        let roomID = extractRoomID(from: userInfo)
        if let activeRoomID = activeChatState?.activeRoomID, activeRoomID == roomID {
            logger.info("현재 활성 채팅방(\(activeRoomID))에서 받은 채팅 알림 무시")
            return []
        }
        
        return [.banner, .list, .sound, .badge]
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        
        let userInfo = response.notification.request.content.userInfo
        logger.error("받은 푸시 데이터: \(userInfo)")
        logger.error("알림 제목: \(response.notification.request.content.title)")
        
        
        if let type = userInfo["type"] as? String, type == "chat",
           let roomID = extractRoomID(from: userInfo) {
            if let activeRoomID = activeChatState?.activeRoomID, activeRoomID == roomID {
                logger.info("현재 활성 채팅방(\(activeRoomID))에서 받은 채팅 알림 클릭, 이동 처리 생략")
                return
            } else if let roomIntID = Int(roomID), let chatRoomIds = tabRouter?.chatRoomIds {
                tabRouter?.switchToChat()
                if chatRoomIds.contains(roomIntID) {
                    navigationRouter?.push(next: .chatDetailView(chatEntry: .room(id: roomIntID)))
                } else {
                    tabRouter?.showChatRoomExitToast = true
                    try? await Task.sleep(for: .seconds(1.5))
                    tabRouter?.showChatRoomExitToast = false
                }
            }
        }
    }
}

// MARK: - MessagingDelegate

extension PushManager: @preconcurrency MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        currentFCMToken = fcmToken
        logger.error("FCM 토큰 수신: \(self.currentFCMToken ?? "없음", privacy: .public)")
    }
}
