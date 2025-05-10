//
//  TradeType.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/16/25.
//

enum TradeType {
    ///상품 유형을 구분하는 enum

    case sell
    case buy
    
    var title: String {
        switch self {
        case .sell: return "판매"
        case .buy: return "구매"
        }
    }
    
    var rawString: String {
        switch self {
        case .sell: return "SELL"
        case .buy: return "BUY"
        }
    }
}
