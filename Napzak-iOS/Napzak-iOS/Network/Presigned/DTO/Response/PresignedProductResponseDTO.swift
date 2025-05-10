//
//  PresignedResponseDTO.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/4/25.
//

typealias PresignedProductResponseDTO = BaseResponseDTO<PresignedProductUrlsData>

struct PresignedProductUrlsData: Decodable {
    let productPresignedUrls: [String: String]
}
