//
//  Napzak_iOSApp.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 3/14/25.
//

import SwiftUI

import FirebaseCore
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct Napzak_iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase

    @StateObject private var activeChatState = ActiveChatState()
    @StateObject private var permission: PushPermissionManager
    @StateObject private var pushManager: PushManager
    @StateObject private var navigationRouter = NavigationRouter()
    @StateObject private var tabRouter = TabRouter()
    
    private let chatStompManager = ChatStompManager.shared
    private var mixpanelManager = MixpanelManager.shared

    init() {
        FirebaseApp.configure()
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey)

        let permission = PushPermissionManager()
        let pushManager = PushManager(permission: permission)
        
        self._permission = StateObject(wrappedValue: permission)
        self._pushManager = StateObject(wrappedValue: pushManager)
        
        appDelegate.pushManager = pushManager
        mixpanelManager.initializeMixpanel()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
                .environmentObject(pushManager)
                .environmentObject(permission)
                .environmentObject(navigationRouter)
                .environmentObject(tabRouter)
                .environmentObject(activeChatState)
                .onAppear {
                    pushManager.navigationRouter = navigationRouter
                    pushManager.tabRouter = tabRouter
                    pushManager.activeChatState = activeChatState
                }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                chatStompManager.connect()
            }
        }
    }
}
