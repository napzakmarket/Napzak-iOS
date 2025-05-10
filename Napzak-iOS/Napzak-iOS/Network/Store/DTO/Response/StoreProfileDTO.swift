//
//  StoreProfileDTO.swift
//  Napzak-iOS
//
//  Created by 어진 on 5/3/25.
//

import Foundation

struct StoreProfileDTO: Decodable {
    let storeId: Int
    let storeNickname: String
    let storePhoto: String? // Optional로 변경
    let totalSellCount: Int
    let totalBuyCount: Int
    let serviceLink: String
}

typealias StoreResponseDTO = BaseResponseDTO<StoreProfileDTO>
