//
//  ReportAPI.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/4/25.
//

import Moya

enum ReportAPI {
    case postProductReport(productId: Int)
    case postStoreReport(storeId: Int)
}

extension ReportAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .postStoreReport, .postProductReport: .accessTokenHeader
        }
    }

    var path: String {
        switch self {
        case .postProductReport(let productId):
            return "products/report/\(productId)"
        case .postStoreReport(let storeId):
            return "stores/report/\(storeId)"
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
            return .requestPlain
        case .postStoreReport(let storeId):
            return .requestPlain
        }
    }

    
}
