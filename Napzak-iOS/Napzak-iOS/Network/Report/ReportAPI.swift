//
//  ReportAPI.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/4/25.
//

import Moya

enum ReportAPI {
    case postProductReport(productId: Int, requestData: ReportRequestDTO)
    case postStoreReport(storeId: Int, requestData: ReportRequestDTO)
}

extension ReportAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .postStoreReport, .postProductReport: .accessTokenHeader
        }
    }

    var path: String {
        switch self {
        case .postProductReport(let productId, _):
            return "products/report/\(productId)"
        case .postStoreReport(let storeId, _):
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
        case .postProductReport(_, let requestData):
            return .requestJSONEncodable(requestData)
        case .postStoreReport(_, let requestData):
            return .requestJSONEncodable(requestData)
        }
    }

    
}
