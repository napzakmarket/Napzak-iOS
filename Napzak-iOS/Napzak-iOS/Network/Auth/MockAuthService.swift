//
//  MockAuthService.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/3/25.
//

import Foundation

final class MockAuthService: AuthServiceProtocol {
    func login(type: SocialLoginType, authorizationCode: String) async -> Result<AuthResponseDTO, NetworkError> {
        let mockData = AuthData(
            accessToken: "mock_access_token",
            refreshToken: "mock_refresh_token",
            nickname: "테스트 유저",
            role: .onboarding
        )
        
        let mockResponse = BaseResponseDTO(
            status: 200,
            message: "Success",
            data: mockData
        )
        
        return .success(mockResponse)
    }
}
