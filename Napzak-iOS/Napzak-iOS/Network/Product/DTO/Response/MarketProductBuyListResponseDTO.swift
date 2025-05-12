//
//  MarketProductBuyListResponseDTO.swift
//  Napzak-iOS
//
//  Created by 어진 on 5/7/25.
//

import Foundation

public struct MarketProductBuyListResponseDTO: Decodable {
    let productCount: Int
    let productBuyList: [ProductDTO]
    let nextCursor: String?
}
