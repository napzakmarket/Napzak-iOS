//
//  ProductCondition.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/6/25.
//


enum ProductCondition: String, CaseIterable, Decodable {
    case new = "NEW"
    case likeNew = "LIKE_NEW"
    case slightlyUsed = "SLIGHTLY_USED"
    case used = "USED"
    
    var label: String {
        switch self {
        case .new: return "미개봉"
        case .likeNew: return "아주 좋은 상태"
        case .slightlyUsed: return "약간의 사용감"
        case .used: return "사용감 있음"
        }
    }
}
