//
//  ProductWithCountDTO.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/10/25.
//

import Foundation

struct ProductWithCountDTO: Decodable {
    let productId: Int
    let genreName: String
    let productName: String
    let photo: String
    let price: Int
    let uploadTime: String
    let isInterested: Bool
    let tradeType: TradeType
    let tradeStatus: TradeStatus
    let isPriceNegotiable: Bool?
    let isOwnedByCurrentUser: Bool
    let interestCount: Int
    let chatCount: Int
}
