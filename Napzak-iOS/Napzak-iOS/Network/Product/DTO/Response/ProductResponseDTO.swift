//
//  ProductResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/10/25.
//

import Foundation

typealias SellProductResponseDTO = BaseResponseDTO<SellProductDTO>
typealias BuyProductResponseDTO = BaseResponseDTO<BuyProductDTO>

struct SellProductDTO: Decodable {
    let productCount: Int
    let productSellList: [ProductDTO]
    var nextCursor: String?
}

struct BuyProductDTO: Decodable {
    let productCount: Int
    let productBuyList: [ProductDTO]
    var nextCursor: String?
}
