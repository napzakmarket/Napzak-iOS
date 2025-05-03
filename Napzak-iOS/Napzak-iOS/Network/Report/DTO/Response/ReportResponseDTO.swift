//
//  ReportResponseDTO.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/4/25.
//

struct ReportProductResponseDTO: Codable {
    let status: Int
    let message: String
    let data: ReportProductResponseData
}

struct ReportStoreResponseDTO: Codable {
    let status: Int
    let message: String
    let data: ReportStoreResponseData
}

struct ReportProductResponseData: Codable {
    let reporterId: Int
    let reportedProductID: Int
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
