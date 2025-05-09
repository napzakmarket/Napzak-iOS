//
//  LoginRequestDTO.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let socialType: String
    
    init(type: SocialLoginType) {
        self.socialType = type.rawValue
    }
}
