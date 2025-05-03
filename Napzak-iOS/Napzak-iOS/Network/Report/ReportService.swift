//
//  ReportService.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/4/25.
//

import Foundation

import Moya

protocol ReportServiceProtocol {
    func postProductReport(productId: Int) async -> Result<Void, NetworkError>
    func postStoreReport(storeId: Int) async -> Result<Void, NetworkError>
}

final class ReportService: BaseService, ReportServiceProtocol {
    
    private let provider = MoyaProvider<ReportAPI>.init(plugins: [MoyaPlugin()])

    func postProductReport(productId: Int) async -> Result<Void, NetworkError> {
        return await request(provider, .postProductReport(productId: productId))
    }

    func postStoreReport(storeId: Int) async -> Result<Void, NetworkError> {
        return await request(provider, .postStoreReport(storeId: storeId))
    }
    
}
