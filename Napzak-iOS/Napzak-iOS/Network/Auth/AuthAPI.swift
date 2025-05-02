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
        case .login:
            return "stores/login"
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
            let bodyParameters = [
                "socialType": type.rawValue
            ]
            
            let queryParameters = [
                "authorizationCode": code
            ]
            
            do {
                let data = try JSONSerialization.data(withJSONObject: bodyParameters)
                return .requestCompositeData(
                    bodyData: data,
                    urlParameters: queryParameters
                )
            } catch {
                return .requestPlain
            }
            
        case .refresh:
            return .requestPlain
        }
    }
}
