//
//  PresignedResponseDTO.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/4/25.
//

typealias PresignedProductResponseDTO = BaseResponseDTO<PresignedProductUrlsData>
typealias PresignedStoreResponseDTO = BaseResponseDTO<PresignedStoreUrlsData>
typealias PresignedChatResponseDTO = BaseResponseDTO<PresignedChatUrlsData>

struct PresignedProductUrlsData: Decodable {
    let productPresignedUrls: [String: String]
}

struct PresignedStoreUrlsData: Decodable {
    let profilePresignedUrls: [String: String]
}

struct PresignedChatUrlsData: Decodable {
    let chatPresignedUrls: [String: String]
}
