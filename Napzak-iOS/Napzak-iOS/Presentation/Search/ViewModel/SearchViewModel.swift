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

    @Published var selectedTabIndex = 0
    @Published var productFetchOption = ProductFetchOption(sortOption: .recent, genres: [GenreNameModel](), isOnSale: false, isUnopened: false)
    
    @Published var sellProductsCount: Int = 0
    @Published var sellProducts: [ProductItemModel] = []
    @Published var buyProductsCount: Int = 0
    @Published var buyProducts: [ProductItemModel] = []
    @Published var showToast: Bool = false
    @ObservedObject private var likeManager = ProductLikeManager.shared
    
    private(set) var isProcessingLike: Bool = false
    
    private let interestService = NetworkService.shared.interestService
    
    //MARK: - Properties
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "Search")
    
    var searchWord: String = ""
    
    //MARK: - Init
    
    init(
        searchWord: String,
        initialSortOption: SortOption = .recent,
        initialSelectedTab: Int = 0
    ) {
        self.searchWord = searchWord
        self.productFetchOption.sortOption = initialSortOption
        self.selectedTabIndex = initialSelectedTab
        
        Task {
            if searchWord == "" {
                if initialSelectedTab == 0 {
                    await fetchSellProducts()
                } else {
                    await fetchBuyProducts()
                }
            } else {
                if initialSelectedTab == 0 {
                    await fetchSellProductsForSearch()
                } else {
                    await fetchBuyProductsForSearch()
                }
            }
        }
        
        setupLikeObserver()
    }
}

extension SearchViewModel {
    
    //MARK: - Func
    
    func updateProducts() {
        Task {
            if selectedTabIndex == 0 {
                if searchWord.isEmpty {
                    await fetchSellProducts()
                } else {
                    await fetchSellProductsForSearch()
                }
            } else {
                if searchWord.isEmpty {
                    await fetchBuyProducts()
                } else {
                    await fetchBuyProductsForSearch()
                }
            }
        }
    }
    
    //MARK: - API Func
    
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
    
    func fetchSellProductsForSearch() async {
        let result = await NetworkService.shared.productService.getSellProductForSearch(searchWord: searchWord, productFetchOption: productFetchOption)
        
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
    
    func fetchBuyProductsForSearch() async {
        let result = await NetworkService.shared.productService.getBuyProductForSearch(searchWord: searchWord, productFetchOption: productFetchOption)
        
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
    
    func toggleLike(for productId: Int) async {
        guard !isProcessingLike else { return }
        
        isProcessingLike = true
        defer { isProcessingLike = false }
        
        let product = (sellProducts.first { $0.id == productId }) ??
        (buyProducts.first { $0.id == productId })
        
        guard let currentProduct = product else { return }
        
        let result = currentProduct.isInterested ?
        await interestService.deleteInterest(productId: productId) :
        await interestService.postInterest(productId: productId)
        
        switch result {
        case .success:
            let newState = !currentProduct.isInterested
            
            updateProductInterestState(productId: productId, isInterested: newState)
            
            likeManager.productLikeUpdated(productId: productId, isLiked: newState)
            
            if !currentProduct.isInterested {
                showToast = true
                try? await Task.sleep(for: .seconds(2))
                showToast = false
            }
        case .failure(let error):
            logger.error("toggleLike failed: \(error.errorDescription ?? "Unknown error")")
        }
    }
    
    private func updateProductInterestState(productId: Int, isInterested: Bool) {
        if let index = sellProducts.firstIndex(where: { $0.id == productId }) {
            sellProducts[index].isInterested = isInterested
        }
        if let index = buyProducts.firstIndex(where: { $0.id == productId }) {
            buyProducts[index].isInterested = isInterested
        }
    }
    
    private func setupLikeObserver() {
        Task {
            for await _ in likeManager.$updatedProductId.values {
                if let productId = likeManager.updatedProductId,
                   let newState = likeManager.newLikeState {
                    
                    if let index = sellProducts.firstIndex(where: { $0.id == productId }) {
                        sellProducts[index].isInterested = newState
                        sellProducts[index].interestCount += newState ? 1 : -1
                    }
                    
                    if let index = buyProducts.firstIndex(where: { $0.id == productId }) {
                        buyProducts[index].isInterested = newState
                        buyProducts[index].interestCount += newState ? 1 : -1
                    }
                }
            }
        }
    }
}
