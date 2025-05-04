//
//  RegisterModel.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/29/25.
//

import SwiftUI

enum ProductCondition: CaseIterable {
    case NEW
    case LIKE_NEW
    case SLIGHTLY_USED
    case USED
    
    var label: String {
        switch self {
        case .NEW: return "미개봉"
        case .LIKE_NEW: return "아주 좋은 상태"
        case .SLIGHTLY_USED: return "약간의 사용감"
        case .USED: return "사용감 있음"
        }
    }
    
    var rawString: String {
        switch self {
        case .NEW: return "NEW"
        case .LIKE_NEW: return "LIKE_NEW"
        case .SLIGHTLY_USED: return "SLIGHTLY_USED"
        case .USED: return "USED"
        }
    }
}

struct RegisterModel {
    // Shared
    var images: [UIImage] = []
    var title: String = ""
    var description: String = ""
    var price: String = ""
    var genre: String = ""
    var genreId: Int?
    
    // Sell
    var productCondition: ProductCondition?
    var isDeliveryIncluded: Bool?
    var standardDeliveryFee: String = "0"
    var halfDeliveryFee: String = "0"
    
    // Buy
    var isPriceNegotiable: Bool = false
}
