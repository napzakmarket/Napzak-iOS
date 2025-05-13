//
//  ReportResponseDTO.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/4/25.
//

typealias ReportProductResponseDTO = BaseResponseDTO<ReportProductResponseData>
typealias ReportStoreResponseDTO = BaseResponseDTO<ReportStoreResponseData>

struct ReportProductResponseData: Codable {
    let reporterId: Int
    let reportedProductID: Int?
    let reportTitle: String
    let reportDescription: String
    let reportContact: String
}

struct ReportStoreResponseData: Codable {
    let reporterId: Int
    let reportedStoreId: Int
    let reportTitle: String
    let reportDescription: String
    let reportContact: String
}
