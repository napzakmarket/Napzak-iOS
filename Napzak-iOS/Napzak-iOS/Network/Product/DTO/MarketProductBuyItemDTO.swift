//
//  MarketProductBuyItemDTO.swift
//  Napzak-iOS
//
//  Created by 어진 on 5/7/25.
//

import Foundation

public struct MarketProductBuyItemDTO: Codable {
    let productId: Int
    let genreName: String
    let productName: String
    let photo: String
    let price: Int
    let uploadTime: String
    let isLiked: Bool
    let tradeType: String
    let tradeStatus: String
    let isPriceNegotiable: Bool
    let isOwnedByCurrentUser: Bool
    let interestCount: Int
    let chatCount: Int
}
