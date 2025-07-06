//
//  AppDelegate.swift
//  Napzak-iOS
//
//  Created by 조호근 on 7/6/25.
//

import UIKit
import UserNotifications

import Firebase
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var pushManager: PushSettingManager?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        Task {
            await pushManager?.refreshOSPushStatus()
        }

        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        guard let shouldShowPush = pushManager?.shouldShowPush,
              shouldShowPush else {
            print("앱/OS 알림꺼짐 -> 알림 무시")
            return []
        }
        
        // TODO: - 채팅방일 때 알림 안 받도록
        
        return [.banner, .list, .badge, .sound]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        print("받은 푸시 데이터: ", userInfo)
        print("알림 제목: ", response.notification.request.content.title)
    }
    
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        // TODO: - FCM토큰 서버에 전달해야함
        print("FCM 토큰: \(fcmToken ?? "없음")")
    }
    
}
