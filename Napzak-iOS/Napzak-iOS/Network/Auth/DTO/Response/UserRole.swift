//
//  UserRole.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import Foundation

enum UserRole: String, Decodable {
    case store = "STORE"
    case onboarding = "ONBOARDING"
    case withdrawn = "WITHDRAWN"
    case reported = "REPORTED"
    
    var description: String {
        switch self {
        case .store: return "스토어"
        case .onboarding: return "온보딩 미완료"
        case .withdrawn: return "탈퇴 후 온보딩 미완료"
        case .reported: return "신고된 유저"
        }
    }
    
    var needsOnboarding: Bool {
        switch self {
        case .store, .reported:
            return false
        case .onboarding, .withdrawn:
            return true
        }
    }
}
