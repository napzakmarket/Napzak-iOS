//
//  ProductItemResponseDTO.swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/10/25.
//

import Foundation

typealias ProductItemResponseDTO = BaseResponseDTO<ProductRecommendListData>

struct ProductRecommendListData: Decodable {
    let nickname: String
    let productRecommendList: [ProductWithCountDTO]
}
