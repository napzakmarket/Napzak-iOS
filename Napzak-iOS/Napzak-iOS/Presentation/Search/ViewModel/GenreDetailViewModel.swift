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
    @Published var productFetchOption = ProductFetchOption(
        sortOption: .recent,
        genres: [GenreNameModel](),
        isOnSale: false,
        isUnopened: false
    )
    @Published var dummyProducts: [ProductItemModel] = []
    @Published var genreInfo: GenreInfoModel = GenreInfoModel(
        genreId: 0,
        genreName: "",
        tag: "",
        coverImageUrl: ""
    )
    
    //MARK: - Init

    init(genreId: Int, genreName: String) {
        productFetchOption = ProductFetchOption(
            sortOption: .recent,
            genres: [GenreNameModel(id: genreId, name: genreName)],
            isOnSale: false,
            isUnopened: false
        )

        fetchGenreInfo(genreId: genreId, genreName: genreName)
        fetchProducts()
    }
}

extension GenreDetailViewModel {
    
    //MARK: - Func
    
    func fetchGenreInfo(genreId: Int, genreName: String) {
        genreInfo = GenreInfoModel(
            genreId: genreId,
            genreName: genreName,
            tag: "지금핫한",
            coverImageUrl: "https://kream-phinf.pstatic.net/MjAyNDEyMTFfMjAw/MDAxNzMzODkzNTExNDUz.7bZDbRzaJ-jhBHficneUKET4CyE_kfaaOxLvoODV2gg.PNG/a_61618fd382884ad3b37ce139cf1a4147.png?type=m_webp"
        )
    }

    func fetchProducts() {
        dummyProducts = ProductItemModel.dummyProducts
    }
    
    func canToggleInterestState(productID: Int) -> Bool {
        //TODO: - 좋아요 서버 통신 후 성공 여부 반환
        return true
    }
}
