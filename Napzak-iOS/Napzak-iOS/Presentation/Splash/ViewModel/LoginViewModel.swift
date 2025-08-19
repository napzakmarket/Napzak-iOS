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
    @Published var showAlert = false
    
    private(set) var alertTitle: String = ""
    private(set) var alertMessage: String = ""
    
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
            if case .reportedUser = error {
                self.alertTitle = "접근이 불가합니다."
                self.alertMessage = "정책 위반으로 인해 앱 서비스 접근이 불가합니다."
            } else {
                self.alertTitle = "로그인 오류"
                self.alertMessage = "로그인에 실패했습니다. 다시 시도해주세요."
            }
            
            self.showAlert = true
            
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
            if case .reportedUser = error {
                self.alertTitle = "접근이 불가합니다"
                self.alertMessage = "정책 위반으로 인해 앱 서비스 접근이 불가합니다."
            } else {
                self.alertTitle = "로그인 오류"
                self.alertMessage = "로그인에 실패했습니다. 다시 시도해주세요."
            }
            
            self.showAlert = true
            
            logger.error("로그인 실패: \(String(describing: error))")
        }
    }
}
