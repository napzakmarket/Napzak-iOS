//
//  ProductDetailModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/6/25.
//

struct ProductDetailModel {
    var isInterested: Bool
    let productDetail: ProductDetailInfo
    let productPhotoList: [ProductPhotoInfo]
    let storeInfo: StoreInfo
}

struct ProductDetailInfo: Identifiable {
    let id: Int
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
    let tradeStatus: TradeStatus
    let isOwnedByCurrentUser: Bool
    let chatCount: Int
}

struct ProductPhotoInfo: Identifiable {
    let id: Int
    let photoUrl: String
    let photoSequence: Int
}

struct StoreInfo: Identifiable {
    let id: Int
    let storePhoto: String
    let nickname: String
    let totalSellCount: Int
    let totalBuyCount: Int
}
