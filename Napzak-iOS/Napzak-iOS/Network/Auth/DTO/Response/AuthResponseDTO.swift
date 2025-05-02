//
//  AuthResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import Foundation

typealias AuthResponseDTO = BaseResponseDTO<AuthData>

struct AuthData: Decodable {
    let accessToken: String
    let refreshToken: String
    let nickname: String
    let role: UserRole
}
