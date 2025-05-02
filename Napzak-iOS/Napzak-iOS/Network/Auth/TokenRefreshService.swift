//
//  TokenRefreshService.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import Foundation
import Moya

protocol TokenRefreshServiceProtocol {
    func refresh() async -> Result<TokenResponseDTO, NetworkError>
}

final class TokenRefreshService: BaseService, TokenRefreshServiceProtocol {
    private let provider = MoyaProvider<AuthAPI>(plugins: [MoyaPlugin()])

    func refresh() async -> Result<TokenResponseDTO, NetworkError> {
        await request(provider, .refresh)
    }
}
