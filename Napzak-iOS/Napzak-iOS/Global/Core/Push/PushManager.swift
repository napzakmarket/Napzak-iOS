//
//  PushManager.swift
//  Napzak-iOS
//
//  Created by 조호근 on 7/8/25.
//

import UIKit
import UserNotifications
import FirebaseMessaging
import Combine
import os

@MainActor
final class PushManager: NSObject, ObservableObject {
    static let shared = PushManager(permission: PushPermissionManager())
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "PushManager")
    
    @Published private(set) var currentFCMToken: String?
    
    private let permission: PushPermissionService
    private let pushService = NetworkService.shared.pushService
    
    private var cancellables = Set<AnyCancellable>()
    
    init(permission: PushPermissionService) {
        self.permission = permission
        super.init()
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        observePushToggle()
    }
    
    func configureNotifications() async {
        guard await permission.requestNotificationPermission() else { return }
    }
    
    private func observePushToggle() {
        guard let perm = permission as? PushPermissionManager else { return }
        perm.$isAppPushEnabled
            .dropFirst()
            .sink { [weak self] newValue in
                guard let fcmToken = self?.currentFCMToken else { return }
                 Task {
                     await self?.pushService.updatePushSetting(fcmToken: fcmToken, isEnabled: newValue)
                 }
            }
            .store(in: &cancellables)
    }
    
    private func upsertTokenIfNeeded() {
        guard let token = currentFCMToken else { return }
        let request = PushTokenRequestDTO(
            deviceToken: token,
            isEnabled:   permission.isOSPushEnabled,
            allowMessage: permission.isAppPushEnabled
        )
        Task { await pushService.upsertToken(request: request) }
    }
    
}

extension PushManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        
        guard permission.shouldShowPush else {
            print("앱/OS 알림꺼짐 -> 알림 무시")
            return []
        }
        
        // TODO: - 채팅방일 때 알림 안 받도록
        
        return [.banner, .list, .sound, .badge]
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        // TODO: - deep link 처리 or Chat 이동 로직
        
        let userInfo = response.notification.request.content.userInfo
        print("받은 푸시 데이터: ", userInfo)
        print("알림 제목: ", response.notification.request.content.title)
    }
}

extension PushManager: @preconcurrency MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // TODO: - FCM토큰 서버에 전달해야함
        logger.error("FCM 토큰 수신: \(fcmToken ?? "없음")")
        currentFCMToken = fcmToken
        
        upsertTokenIfNeeded()
    }
}
