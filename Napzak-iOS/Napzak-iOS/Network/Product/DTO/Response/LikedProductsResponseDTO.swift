//
//  LikedProductsResponse.swift
//  Napzak-iOS
//
//  Created by 어진 on 6/29/25.
//

import Foundation

struct LikedSellProductsResponseDTO: Codable {
    let interestedSellProductList: [LikedSellProductDTO]
}

struct LikedSellProductDTO: Codable {
    let productId: Int
    let genreName: String
    let productName: String
    let photo: String
    let price: Int
    let uploadTime: String
    let isInterested: Bool
    let isOwnedByCurrentUser: Bool
    let tradeType: String
    let tradeStatus: String
    let interestCount: Int
    let chatCount: Int
}

struct LikedBuyProductsResponseDTO: Codable {
    let interestedBuyProductList: [LikedBuyProductDTO]
}

struct LikedBuyProductDTO: Codable {
    let productId: Int
    let genreName: String
    let productName: String
    let photo: String
    let price: Int
    let uploadTime: String
    let isInterested: Bool
    let isOwnedByCurrentUser: Bool
    let tradeType: String
    let tradeStatus: String
    let interestCount: Int
    let chatCount: Int
}

extension LikedSellProductDTO {
    func toProductItemModel() -> ProductItemModel {
        return ProductItemModel(
            id: self.productId,
            genreName: self.genreName,
            productName: self.productName,
            photo: self.photo,
            price: self.price,
            uploadTime: self.uploadTime,
            isInterested: self.isInterested,
            tradeType: TradeType(rawValue: self.tradeType) ?? .sell,
            tradeStatus: TradeStatus(rawValue: self.tradeStatus) ?? .beforeTrade,
            isPriceNegotiable: nil, // 서버 응답에 없으므로 nil
            isOwnedByCurrentUser: self.isOwnedByCurrentUser,
            interestCount: self.interestCount,
            chatCount: self.chatCount
        )
    }
}

extension LikedBuyProductDTO {
    func toProductItemModel() -> ProductItemModel {
        return ProductItemModel(
            id: self.productId,
            genreName: self.genreName,
            productName: self.productName,
            photo: self.photo,
            price: self.price,
            uploadTime: self.uploadTime,
            isInterested: self.isInterested,
            tradeType: TradeType(rawValue: self.tradeType) ?? .buy,
            tradeStatus: TradeStatus(rawValue: self.tradeStatus) ?? .beforeTrade,
            isPriceNegotiable: nil, // 서버 응답에 없으므로 nil
            isOwnedByCurrentUser: self.isOwnedByCurrentUser,
            interestCount: self.interestCount,
            chatCount: self.chatCount
        )
    }
}
