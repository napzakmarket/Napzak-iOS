//
//  Napzak_iOSApp.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 3/14/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct Napzak_iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var pushManager = PushSettingManager()
    
    init() {
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey)
        
        appDelegate.pushManager = pushManager
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
        }
    }
}
