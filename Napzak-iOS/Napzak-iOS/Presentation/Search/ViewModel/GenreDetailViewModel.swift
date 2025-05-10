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
    
    @Published var productFetchOption = ProductFetchOption(
        sortOption: .recent,
        genres: [GenreNameModel](),
        isOnSale: false,
        isUnopened: false
    )
    @Published var genreInfo: GenreInfoModel = GenreInfoModel(
        genreId: 0,
        genreName: "",
        tag: "",
        coverImageUrl: ""
    )
    @Published var sellProductsCount: Int = 0
    @Published var sellProducts: [ProductItemModel] = []
    @Published var buyProductsCount: Int = 0
    @Published var buyProducts: [ProductItemModel] = []
    
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
            await fetchSellProducts()
        }
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

    func fetchSellProducts() async {
        let result = await NetworkService.shared.productService.getSellProduct(productFetchOption: productFetchOption)
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("getSellProduct: No data received")
                return
            }
            
            self.sellProductsCount = data.productCount
            self.sellProducts = data.productSellList.map { ProductItemModel(dto: $0) }
            
        case .failure(let error):
            logger.error("getSellProduct failed: \(error.localizedDescription)")
        }
    }
    
    func fetchBuyProducts() async {
        let result = await NetworkService.shared.productService.getBuyProduct(productFetchOption: productFetchOption)
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("getSellProduct: No data received")
                return
            }
            
            self.buyProductsCount = data.productCount
            self.buyProducts = data.productBuyList.map { ProductItemModel(dto: $0) }
            
        case .failure(let error):
            logger.error("getSellProduct failed: \(error.localizedDescription)")
        }
    }

    func canToggleInterestState(productID: Int) -> Bool {
        //TODO: - 좋아요 서버 통신 후 성공 여부 반환
        return true
    }
}
