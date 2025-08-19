//
//  SearchViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/16/25.
//

import SwiftUI
import Combine
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

    private var cancellables = Set<AnyCancellable>()
    private let likeSubject = PassthroughSubject<(Int, Bool), Never>()
    
    private let interestService = NetworkService.shared.interestService
    
    //MARK: - Properties
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "Search")
    
    let loadingManager = LoadingViewManager()
    var searchWord: String = ""
    
    //MARK: - Init
    
    init() {
        setupLikeObserver()
        setupLikePublisher()
        setupProductEventObserver()
    }
}

extension SearchViewModel {
    
    //MARK: - Func
    
    func fetchProducts(
        searchWord: String,
        sortOption: SortOption,
        selectedTab: Int
    ) async {
        self.searchWord = searchWord
        self.productFetchOption.sortOption = sortOption
        self.selectedTabIndex = selectedTab
        
        loadingManager.startLoading()
        defer { loadingManager.stopLoading() }
        
        if searchWord == "" {
            if selectedTabIndex == 0 {
                await fetchSellProducts()
            } else {
                await fetchBuyProducts()
            }
        } else {
            if selectedTabIndex == 0 {
                await fetchSellProductsForSearch()
            } else {
                await fetchBuyProductsForSearch()
            }
        }
    }
    
    func updateProducts() async {
        Task {
            loadingManager.startLoading()
            defer { loadingManager.stopLoading() }
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
    
    func resetSearchParams() {
        searchWord = ""
        
        productFetchOption = ProductFetchOption(
            sortOption: .recent,
            genres: [],
            isOnSale: false,
            isUnopened: false
        )
        
        selectedTabIndex = 0
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
    
    func toggleLike(for productId: Int) {
        let product = (sellProducts.first { $0.id == productId }) ??
        (buyProducts.first { $0.id == productId })
        
        guard let currentProduct = product else { return }
        
        let newState = !currentProduct.isInterested
        
        updateProductInterestState(productId: productId, isInterested: newState)
        likeManager.productLikeUpdated(productId: productId, isLiked: newState)
        
        if newState {
            showToast = true
            Task {
                try? await Task.sleep(for: .seconds(2))
                await MainActor.run {
                    showToast = false
                }
            }
        }

        likeSubject.send((productId, newState))
    }
    
    private func setupLikePublisher() {
        likeSubject
            .throttle(for: .milliseconds(500), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] (productId, newState) in
                guard let self = self else { return }
                
                Task {
                    let result = newState ?
                    await self.interestService.postInterest(productId: productId) :
                    await self.interestService.deleteInterest(productId: productId)
                    
                    await MainActor.run {
                        if case .failure(let error) = result {
                            self.updateProductInterestState(productId: productId, isInterested: !newState)
                            self.likeManager.productLikeUpdated(productId: productId, isLiked: !newState)
                            self.logger.error("toggleLike failed: \(error.errorDescription ?? "Unknown error")")
                        }
                    }
                }
            }
            .store(in: &cancellables)
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
    
    private func setupProductEventObserver() {
        ProductEventManager.shared.productChanged
            .sink { [weak self] in
                guard let self = self else { return }
                
                Task {
                    await self.updateProducts()
                }
            }
            .store(in: &cancellables)
    }
}
