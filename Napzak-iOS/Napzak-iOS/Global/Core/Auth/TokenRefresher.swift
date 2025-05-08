//
//  TokenRefresher.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import Foundation
import os

actor TokenRefresher {
    static let shared = TokenRefresher()

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "Auth.Refresh")
    
    private let tokenRefreshService = NetworkService.shared.tokenRefreshService
    private var refreshTask: Task<Result<String, NetworkError>, Never>?

    /// 액세스 토큰을 재발급하고 Keychain에 저장합니다.
    ///
    /// 이미 진행 중인 토큰 재발급 작업(`refreshTask`)이 있으면 해당 작업 결과를 재사용합니다.
    ///
    /// 최초 호출 시에만 `service.refresh()`를 통해 새 토큰을 요청하고,
    ///
    /// 성공 시 `KeychainManager.shared.updateAccessToken(_:)`로 저장합니다.
    ///
    /// - Returns: 토큰 갱신 결과를 `Result<String, NetworkError>`로 반환합니다.
    func refresh() async -> Result<String, NetworkError> {
        if let existing = refreshTask {
            logger.debug("Awaiting existing token-refresh task")
            return await existing.value
        }

        let task = Task<Result<String, NetworkError>, Never> {
            let result = await tokenRefreshService.refresh()
            switch result {
            case .success(let dto):
                guard let accessToken = dto.data?.accessToken else {
                    return .failure(.decodingError)
                }
                return .success(accessToken)
                
            case .failure(let err):
                return .failure(err)
            }
        }
        refreshTask = task
        
        let result = await task.value
        refreshTask = nil

        if case .success(let token) = result {
            KeychainManager.shared.updateAccessToken(token)
            logger.info("Token refreshed")
        } else {
            logger.error("Token refresh failed")
        }
        return result
    }
}
