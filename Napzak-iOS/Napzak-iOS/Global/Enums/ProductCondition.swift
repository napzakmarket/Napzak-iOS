//
//  ProductCondition.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/6/25.
//


enum ProductCondition: CaseIterable {
    case new
    case likeNew
    case slightlyUsed
    case used
    
    var label: String {
        switch self {
        case .new: return "미개봉"
        case .likeNew: return "아주 좋은 상태"
        case .slightlyUsed: return "약간의 사용감"
        case .used: return "사용감 있음"
        }
    }
    
    var rawString: String {
        switch self {
        case .new: return "NEW"
        case .likeNew: return "LIKE_NEW"
        case .slightlyUsed: return "SLIGHTLY_USED"
        case .used: return "USED"
        }
    }
}
