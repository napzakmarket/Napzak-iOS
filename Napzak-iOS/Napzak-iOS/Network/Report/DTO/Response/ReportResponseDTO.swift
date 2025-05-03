//
//  ReportResponseDTO.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/4/25.
//

struct ReportResponseDTO: Decodable {
    let status: Int
    let message: String
    let data: ReportResponseData
}

struct ReportResponseData: Codable {
    let reporterId: Int
    let reportedProductID: Int
    let reportTitle: String
    let reportDescription: String
    let reportContact: String
}
