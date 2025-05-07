//
//  ReportService.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/4/25.
//

import Foundation

import Moya

protocol ReportServiceProtocol {
    func postProductReport(productId: Int, requestData: ReportRequestDTO) async -> Result<ReportProductResponseDTO, NetworkError>
    func postStoreReport(storeId: Int, requestData: ReportRequestDTO) async -> Result<ReportStoreResponseDTO, NetworkError>
}

final class ReportService: BaseService, ReportServiceProtocol {
    
    private let provider = MoyaProvider<ReportAPI>.init(plugins: [MoyaPlugin()])

    func postProductReport(productId: Int, requestData: ReportRequestDTO) async -> Result<ReportProductResponseDTO, NetworkError> {
        return await request(provider, .postProductReport(productId: productId, requestData: requestData))
    }

    func postStoreReport(storeId: Int, requestData: ReportRequestDTO) async -> Result<ReportStoreResponseDTO, NetworkError> {
        return await request(provider, .postStoreReport(storeId: storeId, requestData: requestData))
    }

}
