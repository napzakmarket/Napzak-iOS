//
//  ProductDetailResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/11/25.
//

import Foundation

typealias ProductDetailResponseDTO = BaseResponseDTO<ProductDetailDTO>

struct ProductDetailDTO: Decodable {
    var isInterested: Bool
    var productDetail: ProductDetailInfoDTO
    let productPhotoList: [ProductPhotoInfoDTO]
    let storeInfo: StoreInfoDTO
}

struct ProductDetailInfoDTO: Decodable {
    let productId: Int
    let tradeType: TradeType
    let genreName: String
    let productName: String
    let price: Int
    let uploadTime: String
    let interestCount: Int
    let description: String
    let productCondition: ProductCondition?
    let standardDeliveryFee: Int
    let halfDeliveryFee: Int
    let isDeliveryIncluded: Bool
    let isPriceNegotiable: Bool
    var tradeStatus: TradeStatus
    let isOwnedByCurrentUser: Bool
    let chatCount: Int
}

struct ProductPhotoInfoDTO: Decodable {
    let photoId: Int
    let photoUrl: String
    let sequence: Int
}

struct StoreInfoDTO: Decodable {
    let userId: Int
    let storePhoto: String
    let nickname: String
    let totalSellCount: Int
    let totalBuyCount: Int
}
