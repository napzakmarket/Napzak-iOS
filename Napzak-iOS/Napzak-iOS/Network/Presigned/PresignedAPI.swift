//
//  PresignedAPI.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/28/25.
//

import Foundation

import Moya

enum PresignedAPI {
    case getPresignedProductURL(imageNameList: [String])
    case putPresignedProductURL(url: String, imageData: Data)
}

extension PresignedAPI: BaseTargetType {
    
    // 발급받은 PresignedURL에 PUT 요청을 보내야 하기 때문에 BASE URL을 사용하지 않음
    var baseURL: URL {
        switch self {
        case .getPresignedProductURL:
            guard let urlString = Bundle.main.infoDictionary?["BASE_URL"] as? String,
                  let url = URL(string: urlString) else {
                fatalError("🚨Base URL을 찾을 수 없습니다🚨")
            }
            return url
        case .putPresignedProductURL(let url, _):
            return URL(string: url) ?? URL(string: "")!
        }
    }
    
    var headerType: HeaderType {
        switch self {
        case .getPresignedProductURL:
                .noneHeader
        case .putPresignedProductURL:
                .noneHeader
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getPresignedProductURL:
            return nil
        case .putPresignedProductURL:
            return ["Content-Type": "image/jpeg"]
        }
    }

    var path: String {
        switch self {
        case .getPresignedProductURL:
            return "presigned-url/product"
        case .putPresignedProductURL:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .getPresignedProductURL:
            return .get
        case .putPresignedProductURL:
            return .put
        }
    }

    var task: Moya.Task {
        switch self {
        case .getPresignedProductURL(let imageNameList):
            return .requestParameters(parameters: ["productImages" : imageNameList], encoding: URLEncoding.queryString)
        case .putPresignedProductURL(_, let imageData):
            return .requestData(imageData)
        }
    }

}
