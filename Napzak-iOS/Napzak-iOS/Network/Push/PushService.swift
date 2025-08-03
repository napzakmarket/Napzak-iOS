//
//  PushService.swift
//  Napzak-iOS
//
//  Created by 조호근 on 7/8/25.
//

import Foundation
import Moya

protocol PushServiceProtocol {
    func upsertToken(request: PushTokenRequestDTO) async -> Result<Void, NetworkError>
    func fetchPushSetting(fcmToken: String) async -> Result<PushSettingResponseDTO, NetworkError>
    func updatePushSetting(fcmToken: String, isEnabled: Bool) async -> Result<Void, NetworkError>
    func deleteToken(fcmToken: String) async -> Result<Void, NetworkError>
}

final class PushService: BaseService, PushServiceProtocol {
    
    private let provider = MoyaProvider<PushAPI>.init(plugins: [MoyaPlugin()])
    
    func upsertToken(request: PushTokenRequestDTO) async -> Result<Void, NetworkError> {
        return await requestVoid(provider, .upsertToken(request: request))
    }
    
    func fetchPushSetting(fcmToken: String) async -> Result<PushSettingResponseDTO, NetworkError> {
        return await requestDecodable(provider, .fetchPushSetting(fcmToken: fcmToken))
    }
    
    func updatePushSetting(fcmToken: String, isEnabled: Bool) async -> Result<Void, NetworkError> {
        return await requestVoid(provider, .updatePushSetting(fcmToken: fcmToken, isEnabled: isEnabled))
    }
    
    func deleteToken(fcmToken: String) async -> Result<Void, NetworkError> {
        return await requestVoid(provider, .deleteToken(fcmToken: fcmToken))
    }
    
}
