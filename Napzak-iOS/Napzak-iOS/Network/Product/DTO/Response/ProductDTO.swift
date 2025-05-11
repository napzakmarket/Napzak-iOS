//
//  ProductDTO.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/10/25.
//

import Foundation

struct ProductDTO: Decodable {
    let productId: Int
    let genreName: String
    let productName: String
    let photo: String?
    let price: Int
    let uploadTime: String
    var isInterested: Bool
    let tradeType: String
    let tradeStatus: String
    let isPriceNegotiable: Bool?
    let isOwnedByCurrentUser: Bool
    let interestCount: Int
    let chatCount: Int
}
