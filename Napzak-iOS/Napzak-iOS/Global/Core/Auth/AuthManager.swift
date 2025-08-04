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
    private let onboardingManager = OnboardingManager.shared
    private let authService = NetworkService.shared.authService
    
    var isAuthenticated: Bool {
        (try? keychain.getAccessToken().get()) != nil
    }
    
    var needsOnboarding: Bool {
        onboardingManager.getLastCheckpoint() != .completed
    }
    
    private init() {
//        #if DEBUG
//        keychain.clearTokens()
//        OnboardingManager.shared.clearProgress()
//        logger.info("[DEBUG] Keychain cleared for login testing")
//        #endif
        
        if let checkpoint = onboardingManager.getLastCheckpoint() {
            logger.info("Current onboarding checkpoint: \(checkpoint.rawValue)")
        } else {
            logger.info("No onboarding checkpoint found")
        }
        
        switch keychain.getAccessToken() {
        case .success(let token):
            logger.info("Existing accessToken in Keychain: \(token, privacy: .private)")
            
            Task {
                await fetchMyStoreId()
                await fetchChatRoomIdsToWebSocket()
            }
            
        case .failure:
            logger.info("No accessToken found in Keychain at startup")
        }
    }
    
    func login(with type: SocialLoginType) async -> Result<OnboardingStep, AuthError> {
        logger.debug("Starting login with \(type.serviceName)")
        
        let adapter = await type.getAdapter()
        let authResult = await adapter.login()
        
        switch authResult {
        case .success(let code):
            logger.debug("Received authorization code from \(type.serviceName)")
            let serviceResult = await authService.login(type: type, authorizationCode: code)
            
            switch serviceResult {
            case .success(let response):
                guard response.status == 200 else {
                    logger.error("Invalid response status: \(response.status)")
                    return .failure(.invalidResponse)
                }
                
                guard let data = response.data else {
                    logger.error("Missing response data")
                    return .failure(.invalidResponse)
                }
                
                logger.debug("Server response valid - saving tokens")
                
                let onboardingStep: OnboardingStep
                if data.role.needsOnboarding {
                    logger.info("User needs onboarding - starting from terms")
                    onboardingStep = .terms
                    onboardingManager.saveCheckpoint(.terms)
                } else {
                    logger.info("Existing user - onboarding completed")
                    onboardingStep = .completed
                    onboardingManager.saveCheckpoint(.completed)
                }
                
                if case .failure(let error) = keychain.saveTokens(access: data.accessToken, refresh: data.refreshToken) {
                    return .failure(error)
                }
                
                await fetchMyStoreId()
                await fetchChatRoomIdsToWebSocket()

                return .success(onboardingStep)
                
            case .failure(let error):
                logger.error("Server login failed: \(error)")
                return .failure(.networkError)
            }
            
        case .failure(let error):
            logger.error("Social login failed: \(error)")
            return .failure(error)
        }
    }
    
    func logout() async -> Result<Void, AuthError> {
        logger.debug("Starting logout")
        
        let result = await authService.logout()
        switch result {
        case .success(let response):
            if response.status == 200 {
                logger.info("Server logout success")
            } else {
                logger.error("Server logout failed:  - status code: \(response.status)")
                return .failure(.invalidResponse)
            }
        case .failure(let error):
            logger.error("Server logout failed: \(error)")
            return .failure(.networkError)
        }
        
        onboardingManager.clearProgress()
        
        if case .failure(let error) = keychain.clearTokens() {
            logger.error("Keychain clear tokens failed: \(error)")
            return .failure(error)
        }
        logger.info("logout success")
        return .success(())
    }
    
    func getAccessToken() -> Result<String, AuthError> {
        return keychain.getAccessToken()
    }
    
    func getRefreshToken() -> Result<String, AuthError> {
        return keychain.getRefreshToken()
    }
    
    @MainActor
    func completeOnboarding() {
        onboardingManager.saveCheckpoint(.completed)
    }
}

private extension AuthManager {
    
    //MARK: - Private Func (WebSocket 연결 목적)
    
    func fetchChatRoomIdsToWebSocket() async {
        let result = await NetworkService.shared.chatService.getChatRoomIds()
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("getChatRoomIds: No data received")
                return
            }
            
            let roomIds: [Int] = data.chatRoomIds
            ChatStompManager.shared.receivedRoomIdsSubject.send(roomIds)
            
        case .failure(let error):
            logger.error("getChatRoomIds failed: \(error.localizedDescription)")
        }
    }
    
    func fetchMyStoreId() async {
        let result = await NetworkService.shared.chatService.getMyStoreId()
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("getMyStoreId: No data received")
                return
            }
            
            let storeId: Int = data.storeId
            ChatStompManager.shared.receivedMyStoreIdSubject.send(storeId)
            
        case .failure(let error):
            logger.error("getMyStoreId failed: \(error.localizedDescription)")
        }
    }

}
