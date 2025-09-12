//
//  KakaoLoginAdapter.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import os

final class KakaoLoginAdapter: SocialLoginService {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "KakaoLogin")
    
    @MainActor
    func login() async -> Result<String, AuthError> {
        if UserApi.isKakaoTalkLoginAvailable() {
            return await loginWithKakaoTalk()
        } else {
            return await loginWithKakaoAccount()
        }
    }
    
    @MainActor
    private func loginWithKakaoTalk() async -> Result<String, AuthError> {
        return await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    Self.logger.error("KakaoTalk login failed: \(error.localizedDescription)")
                    continuation.resume(returning: .failure(.canceled))
                    return
                }
                
                guard let authCode = oauthToken?.accessToken else {
                    Self.logger.error("KakaoTalk login failed: missing accessToken")
                    continuation.resume(returning: .failure(.loginFailed(service: .kakao)))
                    return
                }
                
                Self.logger.info("KakaoTalk login succeeded")
                continuation.resume(returning: .success(authCode))
            }
        }
    }
    
    @MainActor
    private func loginWithKakaoAccount() async -> Result<String, AuthError> {
        return await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    Self.logger.error("KakaoAccount login failed: \(error.localizedDescription)")
                    continuation.resume(returning: .failure(.canceled))
                    return
                }
                
                guard let authCode = oauthToken?.accessToken else {
                    Self.logger.error("KakaoAccount login failed: missing accessToken")
                    continuation.resume(returning: .failure(.loginFailed(service: .kakao)))
                    return
                }
                
                Self.logger.info("KakaoAccount login succeeded")
                continuation.resume(returning: .success(authCode))
            }
        }
    }
    
    @MainActor
    func logout() async -> Result<Void, AuthError> {
        return await withCheckedContinuation { continuation in
            UserApi.shared.logout { error in
                if let error = error {
                    Self.logger.error("Kakao logout failed: \(error.localizedDescription)")
                    continuation.resume(returning: .failure(.logoutFailed(service: .kakao)))
                    return
                }
                Self.logger.info("Kakao logout succeeded")
                continuation.resume(returning: .success(()))
            }
        }
    }
    
    func getServiceName() -> String {
        return "Kakao"
    }
}
