//
//  AuthManager.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import Foundation
import Combine
import os

final class AuthManager: ObservableObject {
    
    static let shared = AuthManager()
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "Auth")
    private let keychain = KeychainManager.shared
    private let onboardingManager = OnboardingManager.shared
    private let authService = NetworkService.shared.authService
    private let appInstallStateManager = AppInstallStateManager()
    
    @Published var isAuthenticated: Bool
    
    var needsOnboarding: Bool {
        onboardingManager.getLastCheckpoint() != .completed
    }
    
    private init() {
//        #if DEBUG
//        keychain.clearTokens()
//        OnboardingManager.shared.clearProgress()
//        logger.info("[DEBUG] Keychain cleared for login testing")
//        #endif
        switch appInstallStateManager.clearKeychainIfNeededOnFirstLaunch() {
        case .success(true):
            logger.info("First launch detected. Cleared persisted Keychain tokens.")
        case .success(false):
            break
        case .failure(let error):
            logger.error("Failed to clear Keychain tokens on first launch: \(error.localizedDescription)")
        }

        let hasStoredTokens = Self.hasStoredTokens(in: keychain)
        self.isAuthenticated = hasStoredTokens
        
        if let checkpoint = onboardingManager.getLastCheckpoint() {
            logger.info("Current onboarding checkpoint: \(checkpoint.rawValue)")
        } else {
            logger.info("No onboarding checkpoint found")
        }
        
        if hasStoredTokens {
            logger.info("Existing accessToken and refreshToken found in Keychain")
            Task {
                await fetchMyStoreId()
                await fetchChatRoomIdsToWebSocket()
            }
        } else {
            logger.info("No complete token pair found in Keychain at startup")
        }
    }

    private static func hasStoredTokens(in keychain: KeychainManager) -> Bool {
        (try? keychain.getAccessToken().get()) != nil &&
        (try? keychain.getRefreshToken().get()) != nil
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
                
                if data.role == .reported {
                    logger.error("Reported user login attempt blocked.")
                    return .failure(.reportedUser)
                }
                
                logger.debug("Server response valid - saving tokens")
                
                let onboardingStep: OnboardingStep
                if data.role.needsOnboarding {
                    let savedCheckpoint = onboardingManager.getLastCheckpoint()
                    let resumedStep = savedCheckpoint == .completed ? nil : savedCheckpoint

                    onboardingStep = resumedStep ?? .terms
                    logger.info("User needs onboarding - resuming from \(onboardingStep.rawValue)")
                    onboardingManager.saveCheckpoint(onboardingStep)
                } else {
                    logger.info("Existing user - onboarding completed")
                    onboardingStep = .completed
                    onboardingManager.saveCheckpoint(.completed)
                } 
                
                if case .failure(let error) = keychain.saveTokens(access: data.accessToken, refresh: data.refreshToken) {
                    return .failure(error)
                } else {
                    logger.info("Successfully saved tokens to Keychain.")
                }
                
                return .success(onboardingStep)
                
            case .failure(let error):
                switch error {
                case .reportedUser:
                    logger.error("Reported user login attempt blocked.")
                    return .failure(.reportedUser)
                    
                default:
                    logger.error("Server login failed: \(error)")
                    return .failure(.networkError)
                }
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
            }
        case .failure(let error):
            logger.error("Server logout failed: \(error)")
        }
        
        onboardingManager.clearProgress()
        
        if case .failure(let error) = keychain.clearTokens() {
            logger.error("Keychain clear tokens failed: \(error)")
            return .failure(error)
        } else {
            logger.info("Successfully cleared tokens from Keychain.")
        }
        logger.info("logout success")
        
        await MainActor.run {
            self.isAuthenticated = false
        }
        
        return .success(())
    }
    
    func getAccessToken() -> Result<String, AuthError> {
        return keychain.getAccessToken()
    }
    
    func getRefreshToken() -> Result<String, AuthError> {
        return keychain.getRefreshToken()
    }

    @MainActor
    func startAuthenticatedSession() {
        self.isAuthenticated = true
    }
    
    @MainActor
    func completeOnboarding() {
        onboardingManager.saveCheckpoint(.completed)
        
        Task {
            await fetchMyStoreId()
            await fetchChatRoomIdsToWebSocket()
        }
    }
    
    @MainActor
    func forceLogout() {
        keychain.clearTokens()
        onboardingManager.clearProgress()
        self.isAuthenticated = false
    }
}

final class AppInstallStateManager {
    private let defaults: UserDefaults
    private let installMarkerKey = "app_HasLaunchedBefore"
    private let keychainClearAction: () -> Result<Void, AuthError>

    init(
        defaults: UserDefaults = .standard,
        keychainClearAction: @escaping () -> Result<Void, AuthError> = {
            KeychainManager.shared.clearTokens()
        }
    ) {
        self.defaults = defaults
        self.keychainClearAction = keychainClearAction
    }

    func clearKeychainIfNeededOnFirstLaunch() -> Result<Bool, AuthError> {
        guard defaults.object(forKey: installMarkerKey) == nil else {
            return .success(false)
        }

        switch keychainClearAction() {
        case .success:
            defaults.set(true, forKey: installMarkerKey)
            return .success(true)
        case .failure(let error):
            return .failure(error)
        }
    }
}

extension AuthManager {
    
    //MARK: - Func (WebSocket 연결 목적)
    
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
