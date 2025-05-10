//
//  AppleLoginAdapter.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/4/25.
//

import Foundation
import AuthenticationServices
import os

final class AppleLoginAdapter: NSObject, SocialLoginService {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "AppleLogin")
    private var continuation: CheckedContinuation<Result<String, AuthError>, Never>?
    
    @MainActor
    func login() async -> Result<String, AuthError> {
        return await withCheckedContinuation { continuation in
            self.continuation = continuation
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    
    @MainActor
    func logout() async -> Result<Void, AuthError> {
        return .success(())
    }
    
    func getServiceName() -> String {
        return "Apple"
    }
}

extension AppleLoginAdapter: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let authorizationCode = appleIDCredential.authorizationCode,
              let authCode = String(data: authorizationCode, encoding: .utf8) else {
            Self.logger.error("Failed to get Apple ID credential")
            continuation?.resume(returning: .failure(.loginFailed(service: .apple)))
            continuation = nil
            return
        }
        
        Self.logger.info("Apple login succeeded")
        Self.logger.info("\(appleIDCredential.description)")
        continuation?.resume(returning: .success(authCode))
        continuation = nil

    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Self.logger.error("Apple login failed: \(error.localizedDescription)")
        
        if let authError = error as? ASAuthorizationError {
            switch authError.code {
            case .canceled:
                continuation?.resume(returning: .failure(.loginFailed(service: .apple)))
            default:
                continuation?.resume(returning: .failure(.loginFailed(service: .apple)))
            }
        } else {
            continuation?.resume(returning: .failure(.loginFailed(service: .apple)))
        }
        
        continuation = nil
    }
}

extension AppleLoginAdapter: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else {
            return UIWindow()
        }
        return window
    }
}
