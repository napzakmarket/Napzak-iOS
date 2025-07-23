//
//  PushPermissionManager.swift
//  Napzak-iOS
//
//  Created by 조호근 on 7/6/25.
//

import UIKit
import UserNotifications

@MainActor
final class PushPermissionManager: ObservableObject, PushPermissionService {
    @Published var isAppPushEnabled: Bool = true
    @Published var isOSPushEnabled: Bool = false
    
    var shouldShowPush: Bool {
        isAppPushEnabled && isOSPushEnabled
    }
    
    var pushOffState: PushOffState? {
        switch (isAppPushEnabled, isOSPushEnabled) {
        case (false, true):
            return .appOnlyOff
        case (true, false):
            return .osOnlyOff
        case (false, false):
            return .bothOff
        case (true, true):
            return nil
        }
    }
    
    func refreshOSPushStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        isOSPushEnabled = (settings.authorizationStatus == .authorized)
    }
    
    func requestNotificationPermission() async -> Bool {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        
        if settings.authorizationStatus == .notDetermined {
            let granted = try? await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
            
            isOSPushEnabled = granted ?? false
            
            if granted == true {
                isAppPushEnabled = true
                UIApplication.shared.registerForRemoteNotifications()
            }
            
            return isOSPushEnabled
        } else {
            isOSPushEnabled = (settings.authorizationStatus == .authorized)
            return isOSPushEnabled
        }
    }
}
