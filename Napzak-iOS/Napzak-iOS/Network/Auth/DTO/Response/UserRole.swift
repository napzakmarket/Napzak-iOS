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
    
    var description: String {
        switch self {
        case .store: return "스토어"
        case .onboarding: return "온보딩 미완료"
        }
    }
}
