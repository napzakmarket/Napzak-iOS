//
//  ReportAPI.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/4/25.
//

import Moya

enum ReportAPI {
    case postProductReport(productId: String)
    case postStoreReport(storeId: String)
}

extension ReportAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .postStoreReport, .postProductReport: .accessTokenHeader
        }
    }

    var path: String {
        switch self {
        case .postProductReport:
            return "api/v1/products/report"
        case .postStoreReport:
            return "/api/v1/stores/report"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postProductReport:
            return .post
        case .postStoreReport:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .postProductReport(let productId):
            return .requestParameters(
                parameters: ["productId" : productId],
                encoding: URLEncoding.queryString
            )
        case .postStoreReport(let storeId):
            return .requestParameters(
                parameters: ["storeId" : storeId],
                encoding: URLEncoding.queryString
            )
        }
    }

    
}
