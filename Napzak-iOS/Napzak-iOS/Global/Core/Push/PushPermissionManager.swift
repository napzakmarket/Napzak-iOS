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
    
    @Published var isAppPushEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isAppPushEnabled, forKey: "isAppPushEnabled")
        }
    }
    @Published var isOSPushEnabled: Bool = false
    
    // MARK: - Init
    
    init() {
        self.isAppPushEnabled = UserDefaults.standard.object(forKey: "isAppPushEnabled") as? Bool ?? true
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
            
            if granted == true && UserDefaults.standard.object(forKey: "isAppPushEnabled") == nil {
                isAppPushEnabled = true
            }
            
            if granted == true {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
            return isOSPushEnabled
        } else {
            isOSPushEnabled = (settings.authorizationStatus == .authorized)
            
            if isOSPushEnabled {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
            return isOSPushEnabled
        }
    }
}
