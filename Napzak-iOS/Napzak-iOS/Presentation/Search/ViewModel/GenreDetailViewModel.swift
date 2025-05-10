//
//  GenreDetailViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/29/25.
//

import SwiftUI

import os

@MainActor
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
    
    //MARK: - Properties
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "GenreDetail")
    
    //MARK: - Init

    init(genreId: Int, genreName: String) {
        productFetchOption = ProductFetchOption(
            sortOption: .recent,
            genres: [GenreNameModel(id: genreId, name: genreName)],
            isOnSale: false,
            isUnopened: false
        )

        Task {
            await fetchGenreInfo(genreId: genreId)
        }
        fetchProducts()
    }
}

extension GenreDetailViewModel {
    
    //MARK: - Func
    
    func fetchGenreInfo(genreId: Int) async {
        let result = await NetworkService.shared.genreService.getGenreDetailInfo(genreId: genreId)

        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("getGenreDetailInfo: No data received")
                return
            }
            
            self.genreInfo = GenreInfoModel(dto: data)
            
        case .failure(let error):
            logger.error("getGenreDetailInfo failed: \(error.localizedDescription)")
        }
    }

    func fetchProducts() {
        dummyProducts = ProductItemModel.dummyProducts
    }
    
    func canToggleInterestState(productID: Int) -> Bool {
        //TODO: - 좋아요 서버 통신 후 성공 여부 반환
        return true
    }
}
