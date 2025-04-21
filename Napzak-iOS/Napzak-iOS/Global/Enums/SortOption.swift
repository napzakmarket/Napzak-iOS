//
//  SortOption.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/16/25.
//

enum SortOption: String {
    ///상품의 정렬 기준을 구분하는 enum

    case recent = "RECENT"
    case popular = "POPULAR"
    case highPrice = "HIGH_PRICE"
    case lowPrice = "LOW_PRICE"
    
    var title: String {
        switch self {
        case .recent:
            return "최신순"
        case .popular:
            return "인기순"
        case .highPrice:
            return "고가순"
        case .lowPrice:
            return "저가순"
        }
    }
}
