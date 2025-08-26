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
    
    private var lastAppPushState: Bool
    
    // MARK: - Init
    
    init() {
        self.lastAppPushState = UserDefaults.standard.object(forKey: "isAppPushEnabled") as? Bool ?? true
        self.isAppPushEnabled = self.lastAppPushState
        
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
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        
        if settings.authorizationStatus == .notDetermined {
            let granted = try? await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
            
            self.lastAppPushState = granted ?? false
            self.isAppPushEnabled = self.lastAppPushState
            
            if granted == true {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
            self.isOSPushEnabled = granted ?? false
            return self.isOSPushEnabled
        } else {
            self.isOSPushEnabled = (settings.authorizationStatus == .authorized)
            if self.isOSPushEnabled {
                UIApplication.shared.registerForRemoteNotifications()
            }
            return self.isOSPushEnabled
        }
    }
    
    func refreshOSPushStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        let isAuthorized = (settings.authorizationStatus == .authorized)
        
        self.isOSPushEnabled = isAuthorized
        
        if isAuthorized {
            self.isAppPushEnabled = self.lastAppPushState
        } else {
            self.isAppPushEnabled = false
        }
    }
    
    func toggleAppPushEnabled(to newValue: Bool) {
        self.isAppPushEnabled = newValue
        self.lastAppPushState = newValue
        UserDefaults.standard.set(newValue, forKey: "isAppPushEnabled")
    }
}
