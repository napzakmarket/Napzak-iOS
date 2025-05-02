//
//  SocialLoginType.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import Foundation

enum SocialLoginType: String {
    case kakao = "KAKAO"
//    case apple = "APPLE"
    
    var serviceName: String {
        switch self {
        case .kakao: return "Kakao"
//        case .apple: return "Apple"
        }
    }
    
    @MainActor
    func getAdapter() -> SocialLoginService {
        switch self {
        case .kakao: KakaoLoginAdapter()
        }
    }
}
