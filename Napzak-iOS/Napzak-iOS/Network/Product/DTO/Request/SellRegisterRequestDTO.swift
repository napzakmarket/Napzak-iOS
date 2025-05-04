//
//  SellRegisterRequestDTO.swift
//  Napzak-iOS
//
//  Created by OneTen on 5/5/25.
//

import Foundation

struct SellRegisterRequestDTO: Codable {
    let productPhotoList: [SellRegisterRequestPhotoList]
    let genreId: Int
    let title: String
    let description: String
    let price: Int
    let productCondition: String
    let isDeliveryIncluded: Bool
    let standardDeliveryFee: Int
    let halfDeliveryFee: Int
}

struct SellRegisterRequestPhotoList: Codable {
    let photoUrl: String
    let sequence: Int
}
