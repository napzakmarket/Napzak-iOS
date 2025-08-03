//
//  PushAPI.swift
//  Napzak-iOS
//
//  Created by 조호근 on 7/8/25.
//

import Moya

enum PushAPI {
    case upsertToken(request: PushTokenRequestDTO)
    case fetchPushSetting(fcmToken: String)
    case updatePushSetting(fcmToken: String, isEnabled: Bool)
    case deleteToken(fcmToken: String)
}

extension PushAPI: BaseTargetType {
    
    var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    var path: String {
        switch self {
        case .upsertToken:
            return "push-tokens"
        case .fetchPushSetting(let token),
             .updatePushSetting(let token, _):
            return "push-tokens/\(token)/settings"
        case .deleteToken(let token):
            return "push-tokens/\(token)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .upsertToken:
            return .post
        case .fetchPushSetting:
            return .get
        case .updatePushSetting:
            return .patch
        case .deleteToken:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .upsertToken(let request):
            return .requestJSONEncodable(request)
            
        case .fetchPushSetting,
                .deleteToken:
            return .requestPlain
            
        case .updatePushSetting(_, let isEnabled):
            return .requestParameters(
                parameters: ["allowMessage": isEnabled],
                encoding: JSONEncoding.default
            )
        }
    }
    
}
