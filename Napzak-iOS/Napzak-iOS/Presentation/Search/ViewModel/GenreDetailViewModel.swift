//
//  GenreDetailViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/29/25.
//

import SwiftUI

final class GenreDetailViewModel: ObservableObject {
    
    //MARK: - Property Wrappers
    
    @Published var selectedTabIndex = 0
    @Published var productFetchOption = ProductFetchOption(sortOption: .recent, genres: [GenreNameModel](), isOnSale: false, isUnopened: false)
    @Published var dummyProducts: [ProductItemModel] = []
    
    //MARK: - Init

    init() {
        fetchProducts()
    }
}

extension GenreDetailViewModel {
    
    //MARK: - Func
    
    func fetchProducts() {
        dummyProducts = ProductItemModel.dummyProducts
    }
    
    func canToggleInterestState(productID: Int) -> Bool {
        //TODO: - 좋아요 서버 통신 후 성공 여부 반환
        return true
    }
}
