//
//  User.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import Foundation

struct User {
    let nickname: String
    let role: UserRole
    private(set) var isOnboardingRequired: Bool = true
    
    init(from authData: AuthData) {
        self.nickname = authData.nickname
        self.role = authData.role
        self.isOnboardingRequired = authData.role == .pending
    }
}
