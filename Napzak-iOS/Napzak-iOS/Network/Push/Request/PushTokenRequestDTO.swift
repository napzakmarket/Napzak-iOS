//
//  PushTokenResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조호근 on 7/8/25.
//

import Foundation

struct PushTokenRequestDTO: Encodable {
    let deviceToken: String
    let platform: String = "IOS"
    let isEnabled: Bool
    let allowMessage: Bool
}
