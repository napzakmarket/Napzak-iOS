//
//  Int+.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 6/30/25.
//

import Foundation

extension Int {
    func convertPriceByTradeType(tradeType: TradeType) -> String {
        return tradeType == .sell
        ? "\(String(self).convertPrice(maxPrice: 1_000_000))원"
        : "\(String(self).convertPrice(maxPrice: 1_000_000))원대"
    }
}
