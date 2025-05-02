//
//  AuthManager.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import Foundation
import os

final class AuthManager {
    static let shared = AuthManager()
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "Auth")
    private let keychain = KeychainManager.shared
    private let authService: AuthService
    
    private init(authService: AuthService = AuthService()) {
        self.authService = authService
    }
    
    func login(with type: SocialLoginType) async -> Result<User, AuthError> {
        logger.debug("Starting login with \(type.serviceName)")
        
        let adapter = await type.getAdapter()
        let authResult = await adapter.login()
        
        switch authResult {
        case .success(let authCode):
            logger.debug("Authorization code received: \(authCode, privacy: .sensitive)")
            
            let serviceResult = await authService.login(type: type, authorizationCode: authCode)
            
            switch serviceResult {
            case .success(let response):
                guard response.status == 200 else {
                    return .failure(.invalidResponse)
                }
                
                guard let data = response.data else {
                    return .failure(.invalidResponse)
                }
                
                logger.debug("Server response valid - saving tokens")
                let accessToken = data.accessToken
                let refreshToken = data.refreshToken
                
                switch keychain.saveTokens(access: accessToken, refresh: refreshToken) {
                case .success:
                    logger.debug("Tokens saved successfully to Keychain")
                    let user = User(from: data)
                    return .success(user)
                    
                case .failure(let error):
                    return .failure(error)
                }
                
            case .failure:
                return .failure(.networkError)
            }
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func logout() async -> Result<Void, AuthError> {
        logger.debug("로그아웃 실행")
        return keychain.clearTokens()
    }
    
    func getAccessToken() -> Result<String, AuthError> {
        return keychain.getAccessToken()
    }
    
    func getRefreshToken() -> Result<String, AuthError> {
        return keychain.getRefreshToken()
    }
}
