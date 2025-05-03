//
//  StoreDTO.swift
//  Napzak-iOS
//
//  Created by 어진 on 5/3/25.
//

struct StoreDTO: Decodable {
    let storeId: Int
    let storeNickname: String
    let storePhoto: String
    let totalSellCount: Int
    let totalBuyCount: Int
    let serviceLink: String
}
