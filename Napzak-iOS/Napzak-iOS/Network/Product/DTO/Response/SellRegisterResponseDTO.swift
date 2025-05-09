//
//  SellRegisterResponseDTO.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/5/25.
//

import Foundation

struct SellRegisterResponseDTO: Decodable {
    let status: Int
    let message: String
    let data: SellRegisterResponseData
}

struct SellRegisterResponseData: Decodable {
    let productId: Int
    let productPhotoList: [SellRegisterResponsePhotoList]
    let genreId: Int
    let title, description, productCondition: String
    let price: Int
    let isDeliveryIncluded: Bool
    let standardDeliveryFee, halfDeliveryFee: Int
    let createdAt: String
    let updatedAt: String?
}

struct SellRegisterResponsePhotoList: Decodable {
    let photoId: Int
    let photoUrl: String
    let sequence: Int
}
