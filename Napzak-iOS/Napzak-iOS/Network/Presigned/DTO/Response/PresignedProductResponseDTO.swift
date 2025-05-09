//
//  PresignedResponseDTO.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/4/25.
//

struct PresignedProductResponseDTO: Decodable {
    let status: Int
    let message: String
    let data: PresignedProductUrlsData
}

struct PresignedProductUrlsData: Decodable {
    let productPresignedUrls: [String: String]
}
