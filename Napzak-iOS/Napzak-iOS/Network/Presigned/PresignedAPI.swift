//
//  PresignedAPI.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Foundation

import Moya

enum PresignedAPI {
    case getProductPresignedURL(imageNameList: [String])
    case getStorePresignedURL(imageNameList: [String])
    case getChatPresignedURL(imageNameList: [String])
    case putPresignedURL(url: String, imageData: Data)
}

extension PresignedAPI: BaseTargetType {
    
    // 발급받은 PresignedURL에 PUT 요청을 보내야 하기 때문에 BASE URL을 사용하지 않음
    var baseURL: URL {
        switch self {
        case .putPresignedURL(let url, _):
            return URL(string: url) ?? URL(string: "")!
        default:
            guard let urlString = Bundle.main.infoDictionary?["BASE_URL"] as? String,
                  let url = URL(string: urlString) else {
                fatalError("🚨Base URL을 찾을 수 없습니다🚨")
            }
            return url
        }
    }
    
    var headerType: HeaderType {
        switch self {
        default:
            return .noneHeader
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .putPresignedURL:
            return ["Content-Type": "image/jpeg"]
        default:
            return nil
        }
    }

    var path: String {
        switch self {
        case .getProductPresignedURL:
            return "presigned-url/product"
        case .getStorePresignedURL:
            return "presigned-url/stores"
        case .getChatPresignedURL:
            return "presigned-url/chat"
        case .putPresignedURL:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .putPresignedURL:
            return .put
        default:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .getProductPresignedURL(let imageNameList):
            return .requestParameters(parameters: ["productImages" : imageNameList], encoding: URLEncoding.queryString)
        case .getStorePresignedURL(let imageNameList):
            return .requestParameters(parameters: ["profileImages" : imageNameList], encoding: URLEncoding.queryString)
        case .getChatPresignedURL(let imageNameList):
            return .requestParameters(parameters: ["chatImages" : imageNameList], encoding: URLEncoding.queryString)
        case .putPresignedURL(_, let imageData):
            return .requestData(imageData)
        }
    }

}
