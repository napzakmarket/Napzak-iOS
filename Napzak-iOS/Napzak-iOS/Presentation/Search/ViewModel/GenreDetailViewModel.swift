//
//  GenreDetailViewModel.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 4/29/25.
//

import SwiftUI
import Combine
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
    
    @Published var showToast: Bool = false
    @ObservedObject private var likeManager = ProductLikeManager.shared
    
    //MARK: - Properties
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "GenreDetail")
    private var cancellables = Set<AnyCancellable>()
    private let likeSubject = PassthroughSubject<(Int, Bool), Never>()
    
    private let interestService = NetworkService.shared.interestService
    //MARK: - Init

    init(genreId: Int, genreName: String) {
        productFetchOption = ProductFetchOption(
            sortOption: .recent,
            genres: [GenreNameModel(id: genreId, name: genreName)],
            isOnSale: false,
            isUnopened: false
        )
        
        setupLikeObserver()
        setupLikePublisher()

        Task {
            await fetchGenreInfo(genreId: genreId)
            await fetchSellProducts()
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

extension GenreDetailViewModel {
    
    //MARK: - Func
    
    func updateProducts() {
        Task {
            if selectedTabIndex == 0 {
                await fetchSellProducts()
            } else {
                await fetchBuyProducts()
            }
        }
    }
    
    func toggleLike(for productId: Int) {
        let currentProducts = selectedTabIndex == 0 ? sellProducts : buyProducts
        guard let currentProduct = currentProducts.first(where: { $0.id == productId }) else {
            logger.error("toggleLike: Product not found with id: \(productId)")
            return
        }
        
        let newState = !currentProduct.isInterested
    
        updateProductInterestState(productId: productId, isInterested: newState)
        likeManager.productLikeUpdated(productId: productId, isLiked: newState)
        
        MixpanelManager.shared.trackEvent(
            event: "Item Liked",
            properties: [
                "post_id": productId,
                "genre_name": currentProduct.genreName,
                "tab": currentProduct.tradeType.mixpanelName,
                "source": "genre_page",
                "action_type": newState ? "add" : "remove"
            ]
        )
        
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
                logger.error("getBuyProduct: No data received")
                return
            }
            
            self.buyProductsCount = data.productCount
            self.buyProducts = data.productBuyList.map { ProductItemModel(dto: $0) }
            
        case .failure(let error):
            logger.error("getBuyProduct failed: \(error.localizedDescription)")
        }
    }
}
