//
//  BuyProductListResponseDTO .swift
//  Napzak-iOS
//
//  Created by 조호근 on 5/10/25.
//

import Foundation

typealias BuyProductListResponseDTO
 = BaseResponseDTO<ProductBuyListData>

struct ProductBuyListData: Decodable {
    let productBuyList: [ProductWithCountDTO]
}
