//
//  UserRole.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import Foundation

enum UserRole: String, Decodable {
    case store = "STORE"
    case pending = "PENDING"
    
    var description: String {
        switch self {
        case .store: return "스토어"
        case .pending: return "미완료"
        }
    }
}
