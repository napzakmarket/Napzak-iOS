//
//  SearchViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/16/25.
//

import SwiftUI

final class SearchViewModel: ObservableObject {
    
    //MARK: - Property Wrappers

    @Published var selectedTabIndex = 0
    @Published var productFetchOption = ProductFetchOption(sortOption: .recent, genres: [GenreNameModel](), isOnSale: false, isUnopened: false)
    @Published var dummyProducts: [ProductItemModel] = []
    
    //MARK: - Init
    
    init() {
        fetchProducts()
    }
}

extension SearchViewModel {
    
    //MARK: - Func
    
    func fetchProducts() {
        dummyProducts = ProductItemModel.dummyProducts
    }
    
    func canToggleInterestState(productID: Int) -> Bool {
        //TODO: - 좋아요 서버 통신 후 성공 여부 반환
        //통신 여부 뿐만 아니라 애초에 네트워크에 연결되어있는지 등도 함께 고려하면 좋을 듯
        return true
    }
}
