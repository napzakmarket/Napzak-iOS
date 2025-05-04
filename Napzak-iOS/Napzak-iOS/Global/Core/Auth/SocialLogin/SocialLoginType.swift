//
//  SocialLoginType.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import Foundation

enum SocialLoginType: String {
    case kakao = "KAKAO"
    case apple = "APPLE"
    
    var serviceName: String {
        switch self {
        case .kakao: return "Kakao"
        case .apple: return "Apple"
        }
    }
    
    var loginPath: String {
        switch self {
        case .kakao: return "stores/login/kakao"
        case .apple: return "stores/login"
        }
    }
    
    var platform: String {
        switch self {
        case .kakao: return "WEB"
        case .apple: return "IOS"
        }
    }
    
    var authorizationQueryKey: String {
        switch self {
        case .kakao: return "accessToken"
        case .apple: return "authorizationCode"
        }
    }
    
    @MainActor
    func getAdapter() -> SocialLoginService {
        switch self {
        case .kakao: KakaoLoginAdapter()
        case .apple: AppleLoginAdapter()
        }
    }
}
