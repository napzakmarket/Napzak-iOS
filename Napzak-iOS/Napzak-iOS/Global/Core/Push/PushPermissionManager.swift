//
//  PushPermissionManager.swift
//  Napzak-iOS
//
//  Created by 조호근 on 7/6/25.
//

import UIKit
import UserNotifications

@MainActor
final class PushPermissionManager: ObservableObject {
    
    // MARK: - Property Wrappers
    
    @Published var isAppPushEnabled: Bool
    @Published var isOSPushEnabled: Bool = false
    
    // MARK: - Init
    
    init() {
        self.isAppPushEnabled = UserDefaults.standard.object(forKey: "isAppPushEnabled") as? Bool ?? false
        
        Task {
            await refreshOSPushStatus()
        }
    }
    
    // MARK: - Properties
    
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
    
    // MARK: - Func
    
    func requestNotificationPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        
        var isAuthorized = (settings.authorizationStatus == .authorized)
        
        if settings.authorizationStatus == .notDetermined {
            if let granted = try? await center.requestAuthorization(options: [.alert, .badge, .sound]) {
                isAuthorized = granted
                if granted {
                    toggleAppPushEnabled(to: true)
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else if isAuthorized {
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        self.isOSPushEnabled = isAuthorized
        return isAuthorized
    }
    
    func refreshOSPushStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        self.isOSPushEnabled = (settings.authorizationStatus == .authorized)
    }
    
    func toggleAppPushEnabled(to newValue: Bool) {
        self.isAppPushEnabled = newValue
        UserDefaults.standard.set(newValue, forKey: "isAppPushEnabled")
    }
}
