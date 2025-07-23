//
//  ChatDetailModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/30/25.
//

struct ChatDetailModel {
    let productInfo: ChatProductInfo
    let chatStoreInfo: ChatStoreInfo
}

struct ChatProductInfo {
    let productId: Int
    let photo: String
    let tradeType: TradeType
    let title: String
    let price: Int
    let isPriceNegotiable: Bool
    let genreName: String
}

struct ChatStoreInfo {
    let storeId: Int
    let nickname: String
    let isWithdrawn: Bool
    let storePhoto: String
}

extension ChatDetailModel {
    static let mock: ChatDetailModel = ChatDetailModel(
        productInfo: ChatProductInfo(
            productId: 1,
            photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s",
            tradeType: .buy,
            title: "은혼 긴토키 히지카타 룩업",
            price: 125000,
            isPriceNegotiable: true,
            genreName: "은혼"
        ),
        chatStoreInfo: ChatStoreInfo(
            storeId: 1,
            nickname: "납자기",
            isWithdrawn: false,
            storePhoto: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOrPQwOTaU_L8EIFpWzLjgiUHc3CcmGEq84A&s"
        )
    )
}
