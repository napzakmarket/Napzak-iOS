//
//  LoginViewModel.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/2/25.
//

import Foundation
import os

@MainActor
final class LoginViewModel: ObservableObject {
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "Login")
    
    @Published var isLoading = false
    
    private let authManager = AuthManager.shared
    private let onboardingManager = OnboardingManager.shared
    
    func handleKakaoLogin(router: AuthNavigationRouter) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        logger.info("카카오 로그인 시작")
        
        let result = await authManager.login(with: .kakao)
        
        switch result {
        case .success(let onboardingStep):
            logger.info("로그인 성공")
            router.push(next: onboardingStep)
            
        case .failure(let error):
            logger.error("로그인 실패: \(String(describing: error))")
        }
    }
    
    func handleAppleAuthCode(router: AuthNavigationRouter) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        logger.info("애플 로그인 시작")
        
        let result = await authManager.login(with: .apple)
        
        switch result {
        case .success(let onboardingStep):
            logger.info("로그인 성공")
            router.push(next: onboardingStep)
            
        case .failure(let error):
            logger.error("로그인 실패: \(String(describing: error))")
        }
    }
}
