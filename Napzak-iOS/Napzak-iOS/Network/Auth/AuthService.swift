//
//  AuthService.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import Foundation
import Moya

protocol AuthServiceProtocol {
    func login(type: SocialLoginType, authorizationCode: String) async throws -> Result<AuthResponseDTO, NetworkError>
}

final class AuthService: BaseService, AuthServiceProtocol {
    
    private let provider = MoyaProvider<AuthAPI>.init(plugins: [MoyaPlugin()])
    
    func login(type: SocialLoginType, authorizationCode: String) async -> Result<AuthResponseDTO, NetworkError> {
        return await request<AuthResponseDTO, AuthAPI>(provider, .login(type: type, code: authorizationCode)
        )
    }
}
