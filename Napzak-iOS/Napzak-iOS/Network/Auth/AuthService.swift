//
//  AuthService.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import Moya

protocol AuthServiceProtocol {
    func login(type: SocialLoginType, authorizationCode: String) async -> Result<AuthResponseDTO, NetworkError>
    func logout() async -> Result<LogoutResponseDTO, NetworkError>
    func withDraw(item: WithDrawRequestDTO) async -> Result<WithDrawResponseDTO, NetworkError>
}

final class AuthService: BaseService, AuthServiceProtocol {
    private let provider = MoyaProvider<AuthAPI>.init(plugins: [MoyaPlugin()])
    
    func login(type: SocialLoginType, authorizationCode: String) async -> Result<AuthResponseDTO, NetworkError> {
        return await requestDecodable(provider, .login(type: type, code: authorizationCode))
    }
    
    func logout() async -> Result<LogoutResponseDTO, NetworkError> {
        return await requestDecodable(provider, .logout)
    }

    func withDraw(item: WithDrawRequestDTO) async -> Result<WithDrawResponseDTO, NetworkError> {
        return await requestDecodable(provider, .withDraw(item: item))
    }
}
