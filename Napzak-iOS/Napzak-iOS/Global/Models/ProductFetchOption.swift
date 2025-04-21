//
//  ProductFetchOption.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/16/25.
//

struct ProductFetchOption: Equatable {
    ///상품의 필터링 상태를 관리하는 구조체

    var sortOption: SortOption
    var genres: [String]
    var isOnSale: Bool
    var isUnopened: Bool
    
    var sortOptionValue: String {
        return sortOption.rawValue
    }
}
