//
//  AuthAPI.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/1/25.
//

import Moya
import Foundation

enum AuthAPI {
    case login(type: SocialLoginType, code: String)
    case refresh
}

extension AuthAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .login:
            return .noneHeader
        case .refresh:
            return .refreshTokenHeader
        }
    }
    
    var path: String {
        switch self {
        case let .login(type, _):
            return type.loginPath
        case .refresh:
            return "stores/refresh-token"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case let .login(type, code):
            let bodyParameters: [String: Any] = [
                "socialType": type.rawValue,
                "platform": type.platform
            ]
            
            let queryParameters: [String: Any] = [
                type.authorizationQueryKey: code
            ]
            
            return .requestCompositeParameters(
                bodyParameters: bodyParameters,
                bodyEncoding: JSONEncoding.default,
                urlParameters: queryParameters
            )
            
        case .refresh:
            return .requestPlain
        }
    }
}
