//
//  SellProductListResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/10/25.
//

import Foundation

typealias SellProductListResponseDTO
 = BaseResponseDTO<ProductSellListData>

struct ProductSellListData: Decodable {
    let productSellList: [ProductWithCountDTO]
}
