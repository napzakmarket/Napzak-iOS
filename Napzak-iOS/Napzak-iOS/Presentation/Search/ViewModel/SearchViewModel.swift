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
    
    private(set) var isProcessingLike: Bool = false
    
    private let interestService = NetworkService.shared.interestService
    
    //MARK: - Properties
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "Search")
    
    private var searchWord: String = ""
    
    //MARK: - Init
    
    init(searchWord: String) {
        self.searchWord = searchWord
        
        Task {
            if searchWord == "" {
                await fetchSellProducts()
            } else {
                await fetchSellProductsForSearch()
            }
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
            updateProductInterestState(productId: productId, isInterested: !currentProduct.isInterested)
            
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
}
