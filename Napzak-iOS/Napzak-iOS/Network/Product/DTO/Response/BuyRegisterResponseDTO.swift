//
//  BuyRegisterResponseDTO.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/5/25.
//

import Foundation

struct BuyRegisterResponseDTO: Codable {
    let status: Int
    let message: String
    let data: BuyRegisterResponseData
}

struct BuyRegisterResponseData: Codable {
    let productId: Int
    let productPhotoList: [BuyRegisterResponsePhotoList]
    let genreId: Int
    let title, description: String
    let price: Int
    let isPriceNegotiable: Bool
    let createdAt: String
    let updatedAt: String?
}

struct BuyRegisterResponsePhotoList: Codable {
    let photoId: Int
    let photoUrl: String
    let sequence: Int
}
