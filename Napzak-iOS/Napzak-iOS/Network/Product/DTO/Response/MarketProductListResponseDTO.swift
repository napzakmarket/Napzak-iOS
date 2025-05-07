//
//  MarketProductListResponseDTO.swift
//  Napzak-iOS
//
//  Created by 어진 on 5/7/25.
//

import Foundation

struct MarketProductListResponseDTO: Decodable {
    let productCount: Int
    let productSellList: [MarketProductItemDTO]
    let nextCursor: String?
}
