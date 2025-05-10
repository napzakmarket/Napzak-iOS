//
//  SearchViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/16/25.
//

import SwiftUI

import os

@MainActor
final class SearchViewModel: ObservableObject {
    
    //MARK: - Property Wrappers

    @Published var productFetchOption = ProductFetchOption(sortOption: .recent, genres: [GenreNameModel](), isOnSale: false, isUnopened: false)
    
    @Published var sellProductsCount: Int = 0
    @Published var sellProducts: [ProductItemModel] = []
    @Published var buyProductsCount: Int = 0
    @Published var buyProducts: [ProductItemModel] = []
    
    @Published var showToast: Bool = false
    
    //MARK: - Properties
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "Search")
    
    //MARK: - Init
    
    init() {
        
        Task {
            await fetchSellProducts()
        }
    }
}

extension SearchViewModel {
    
    //MARK: - Func
    
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
                logger.error("getBuyProduct: No data received")
                return
            }
            
            self.buyProductsCount = data.productCount
            self.buyProducts = data.productBuyList.map { ProductItemModel(dto: $0) }
            
        case .failure(let error):
            logger.error("getBuyProduct failed: \(error.localizedDescription)")
        }
    }
    
    func canPostInterestState(productID: Int) async -> Bool {
        let result = await NetworkService.shared.interestService.postInterest(productId: productID)
        
        var bool = false
        
        switch result {
        case .success:
            bool = true
        case .failure(let error):
            logger.error("postInterest failed: \(error.localizedDescription)")
        }
        
        if bool {
            showToast = true
            try? await Task.sleep(for: .seconds(2))
            showToast = false
        }
        
        return bool
    }
    
    func canDeleteInterestState(productID: Int) async -> Bool {
        let result = await NetworkService.shared.interestService.deleteInterest(productId: productID)
        
        var bool = false
        
        switch result {
        case .success:
            bool = true
        case .failure(let error):
            logger.error("deleteInterest failed: \(error.localizedDescription)")
        }
        
        return bool
    }
}
