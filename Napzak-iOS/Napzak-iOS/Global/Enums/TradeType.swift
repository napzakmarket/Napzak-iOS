//
//  TradeType.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/16/25.
//

enum TradeType: String {
    ///상품 유형을 구분하는 enum

    case sell = "SELL"
    case buy = "BUY"
    
    var title: String {
        switch self {
            case .sell:
            return "판매"
        case .buy:
            return "구매"
        }
    }
}
