//
//  PushSettingManager.swift
//  Napzak-iOS
//
//  Created by 조호근 on 7/6/25.
//

import UIKit
import UserNotifications

@MainActor
final class PushSettingManager: ObservableObject {
    @Published var isAppPushEnabled: Bool = true
    @Published var isOSPushEnabled: Bool = true
    
    var shouldShowPush: Bool {
        isAppPushEnabled && isOSPushEnabled
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
            
            if granted == true {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
            isOSPushEnabled = granted ?? false
            return isOSPushEnabled
        } else {
            isOSPushEnabled = (settings.authorizationStatus == .authorized)
            return isOSPushEnabled
        }
    }
}
