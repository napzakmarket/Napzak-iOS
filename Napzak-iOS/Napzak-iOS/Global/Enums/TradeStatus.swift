//
//  TradeStatus.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/16/25.
//

enum TradeStatus: String, CaseIterable, Decodable {
    ///상품의 거래 상태를 구분하는 enum

    case beforeTrade = "BEFORE_TRADE"
    case reserved = "RESERVED"
    case completed = "COMPLETED"
}
