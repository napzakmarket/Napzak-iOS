//
//  PresignedResponseDTO.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/4/25.
//

struct PresignedProductResponseDTO: Codable {
    let status: Int
    let message: String
    let data: PresignedProductUrlsData
}

struct PresignedProductUrlsData: Codable {
    let productPresignedUrls: [String: String]
}
