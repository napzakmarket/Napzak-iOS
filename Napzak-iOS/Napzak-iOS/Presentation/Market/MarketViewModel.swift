//
//  MarketViewModel.swift
//  Napzak-iOS
//
//  Created by 어진 on 4/30/25.
//

import SwiftUI

import os

@MainActor
final class MarketViewModel: ObservableObject {
    
    @Published var selectedTabIndex = 0
    @Published var productFetchOption = ProductFetchOption(
        sortOption: .recent,
        genres: [],
        isOnSale: false,
        isUnopened: false
    )
    
    @Published var storeDetail: StoreDetailDTO?
    @Published var isLoadingProfile = false
    @Published var profileError: String? = nil
    
    @Published var products: [ProductItemModel] = []
    @Published var isLoadingProducts = false
    @Published var productsError: String? = nil
    @Published var productCount: Int = 0
    @Published var showToast: Bool = false
    
    private let storeId: Int
    
    private let tabs = ["팔아요", "구해요", "리뷰"]
    private var nextCursor: String? = nil
    
    private(set) var isProcessingLike: Bool = false

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "MarketViewModel")

    
    //MARK: - Init
    
    init(storeId: Int) {
        self.storeId = storeId
        
        Task {
            await fetchStoreDetail()
            await fetchProducts()
        }
    }
    
    func fetchStoreDetail() async {
        let result = await NetworkService.shared.storeService.getStoreDetail(storeId: storeId)
        
        switch result {
        case .success(let response):
            guard let data = response.data else {
                logger.error("❌ getMyPageInfo: No data received")
                return
            }
            
            storeDetail = data
            
        case .failure(let error):
            logger.error("❌ getMyPageInfo failed: \(error.localizedDescription)")
        }
    }
    
    func fetchProducts() async {
        isLoadingProducts = true
        productsError = nil
        
        // 탭에 따라 다른 API 호출
        switch selectedTabIndex {
        case 0: // 팔아요 탭
            let result = await NetworkService.shared.productService.getSellProductsForMarket(
                storeOwnerId: storeId, productFetchOption: productFetchOption)
            
            switch result {
            case .success(let response):
                guard let data = response.data else {
                    logger.error("❌ getSellProductsForMarket: No data received")
                    return
                }
                
                self.nextCursor = data.nextCursor
                self.productCount = data.productCount
                self.products = data.productSellList.map { ProductItemModel(dto: $0) }
                
            case .failure(let error):
                logger.error("❌ getSellProductsForMarket failed: \(error.localizedDescription)")
            }
            
        case 1: // 구해요 탭
            let result = await NetworkService.shared.productService.getBuyProductsForMarket(
                storeOwnerId: storeId, productFetchOption: productFetchOption)
            
            switch result {
            case .success(let response):
                guard let data = response.data else {
                    logger.error("❌ getBuyProductsForMarket: No data received")
                    return
                }
                
                self.nextCursor = data.nextCursor
                self.productCount = data.productCount
                self.products = data.productBuyList.map { ProductItemModel(dto: $0) }
                
            case .failure(let error):
                logger.error("❌ getBuyProductsForMarket failed: \(error.localizedDescription)")
            }
            
        default:
            break
        }
        
        isLoadingProducts = false
    }
    
    
    func toggleLike(for productId: Int) async {
        guard !isProcessingLike else { return }
        
        isProcessingLike = true
        defer { isProcessingLike = false }
        
        guard let currentProduct = products.first(where: { $0.id == productId }) else {
            logger.error("toggleLike: Product not found with id: \(productId)")
            return
        }
        
        let result = currentProduct.isInterested ?
        await NetworkService.shared.interestService.deleteInterest(productId: productId) :
        await NetworkService.shared.interestService.postInterest(productId: productId)
        
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
    
    // ADD: 상품 상태 업데이트 함수 추가
    private func updateProductInterestState(productId: Int, isInterested: Bool) {
        if let index = products.firstIndex(where: { $0.id == productId }) {
            products[index].isInterested = isInterested
        }
    }
    
    func getProductCount() -> Int {
        return productCount
    }
}
