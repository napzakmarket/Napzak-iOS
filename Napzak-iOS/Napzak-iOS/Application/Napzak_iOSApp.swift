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
    @StateObject private var phoneVerificationManager = PhoneVerificationManager()
    
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
                .onOpenURL { url in
                    handleUniversalLink(url)
                }
                .environmentObject(pushManager)
                .environmentObject(permission)
                .environmentObject(navigationRouter)
                .environmentObject(tabRouter)
                .environmentObject(activeChatState)
                .environmentObject(phoneVerificationManager)
                .onAppear {
                    pushManager.navigationRouter = navigationRouter
                    pushManager.tabRouter = tabRouter
                    pushManager.activeChatState = activeChatState
                    pushManager.phoneVerificationManager = phoneVerificationManager
                }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                chatStompManager.connect()
            }
        }
    }
    
    private func handleUniversalLink(_ url: URL) {
        if handleHTTPSUniversalLink(url) {
            return
        }
        
        if handleCustomSchemeDeepLink(url) {
            return
        }
    }
    
    private func handleHTTPSUniversalLink(_ url: URL) -> Bool {
        guard url.scheme == "https",
              url.host == "napzak.kro.kr" else {
            return false
        }
        
        let pathComponents = url.pathComponents
        
        guard pathComponents.count >= 3,
              pathComponents[1] == "product",
              let productId = Int(pathComponents[2]) else {
            return false
        }
        
        print("\(productId)번 상품 상세 페이지 이동")
        navigationRouter.push(next: .productDetailView(productId: productId))
        return true
    }
    
    private func handleCustomSchemeDeepLink(_ url: URL) -> Bool {
        guard url.scheme == "napzak",
              url.host == "product" else {
            return false
        }
        
        let pathComponents = url.pathComponents
        
        guard pathComponents.count >= 2,
              let productId = Int(pathComponents[1]) else {
            return false
        }
        
        print("\(productId)번 상품 상세 페이지 이동")
        navigationRouter.push(next: .productDetailView(productId: productId))
        return true
    }
}
