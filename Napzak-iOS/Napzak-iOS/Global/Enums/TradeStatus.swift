//
//  TradeStatus.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/16/25.
//

enum TradeStatus: CaseIterable {
    ///상품의 거래 상태를 구분하는 enum

    case beforeTrade
    case reserved
    case completed
    
    var rawString: String {
        switch self {
        case .beforeTrade: return "BEFORE_TRADE"
        case .reserved: return "RESERVED"
        case .completed: return "COMPLETED"
        }
    }
}
