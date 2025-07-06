//
//  HomeViewModel.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/28/25.
//

import Foundation
import os
import SwiftUICore
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "HomeViewModel")
    
    @Published var banners: HomeBannersModel = .empty
    @Published var selectedBannerIndex: Int = 1
    @Published var timerPaused: Bool = false
    @Published var showLikeToast: Bool = false
    @Published var externalURLToOpen: URL?
    @ObservedObject private var likeManager = ProductLikeManager.shared
    @Published var recommendedProducts: [ProductItemModel] = []
    @Published var popularSellProducts: [ProductItemModel] = []
    @Published var popularBuyProducts: [ProductItemModel] = []

    private var originalUsername: String = ""
    private var username: String {
        if originalUsername.count > 10 {
            return originalUsername.prefix(10) + "..."
        }
        return originalUsername
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let likeSubject = PassthroughSubject<(Int, ProductSection, Bool), Never>()
    
    private let homeService = NetworkService.shared.homeService
    private let interestService = NetworkService.shared.interestService
    
    var recommendedTitle: String { "\(username)님을 위한 맞춤 PICK!" }
    var recommendedSubtitle: String { "\(username)님의 취향에 딱 맞는 아이템들을 모아봤어요."}
    let popularSellTitle = "지금 가장 많이 찜한 납작템"
    let popularSellSubtitle = "놓치면 아쉬운 인기 아이템들을 구경해볼까요?"
    let popularBuyTitle = "다른 유저들은\n어떤 아이템을 찾고 있을까요?"
    let popularBuySubtitle = "놓치면 아쉬운 인기 아이템들을 구경해볼까요?"
    let loadingManager = LoadingViewManager()
    
    init() {
        fetchHomeData()
        setupLikeObserver()
        setupLikePublisher()
    }
    
    func fetchHomeData() {
        fetchBanners()
        fetchRecommendations()
        fetchPopularSell()
        fetchPopularBuy()
    }
    
    func handleBannerTap(_ action: BannerAction) {
        switch action {
        case .external(let url):
            requestOpenExternalURL(url)
        case .genre(let id):
            print("Navigate to genre: \(id)")
        case .none:
            break
        }
    }
    
    func canToggleInterestState(productID: Int, in section: ProductSection) -> Bool {
        let products: [ProductItemModel]
        switch section {
        case .recommended:
            products = recommendedProducts
        case .popularSell:
            products = popularSellProducts
        case .popularBuy:
            products = popularBuyProducts
        }
        
        guard let product = products.first(where: { $0.id == productID }) else { return false }
        return !product.isOwnedByCurrentUser
    }
    
    func toggleLike(for productId: Int, in section: ProductSection) {
        guard let currentProduct = getCurrentProductState(productId, in: section) else {
            logger.error("toggleLike: Product not found with id: \(productId)")
            return
        }
        
        let newState = !currentProduct.isInterested
        
        updateProductInterestState(productId: productId, section: section, isInterested: newState)
        likeManager.productLikeUpdated(productId: productId, isLiked: newState)
        
        if newState {
            showLikeToast = true
            Task {
                try? await Task.sleep(for: .seconds(2))
                await MainActor.run {
                    showLikeToast = false
                }
            }
        }
        
        likeSubject.send((productId, section, newState))
    }
    
    private func setupLikePublisher() {
        likeSubject
            .throttle(for: .milliseconds(500), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] (productId, section, newState) in
                guard let self = self else { return }
                
                Task {
                    let result = newState ?
                    await self.interestService.postInterest(productId: productId) :
                    await self.interestService.deleteInterest(productId: productId)
                    
                    await MainActor.run {
                        if case .failure(let error) = result {
                            self.updateProductInterestState(productId: productId, section: section, isInterested: !newState)
                            self.likeManager.productLikeUpdated(productId: productId, isLiked: !newState)
                            self.logger.error("toggleLike failed: \(error.errorDescription ?? "Unknown error")")
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}

extension HomeViewModel {
    private func setupLikeObserver() {
        Task {
            for await _ in likeManager.$updatedProductId.values {
                if let productId = likeManager.updatedProductId,
                   let newState = likeManager.newLikeState {
                    if let index = recommendedProducts.firstIndex(where: { $0.id == productId }) {
                        recommendedProducts[index].isInterested = newState
                        recommendedProducts[index].interestCount += newState ? 1 : -1
                    }
                    if let index = popularSellProducts.firstIndex(where: { $0.id == productId }) {
                        popularSellProducts[index].isInterested = newState
                        popularSellProducts[index].interestCount += newState ? 1 : -1
                    }
                    if let index = popularBuyProducts.firstIndex(where: { $0.id == productId }) {
                        popularBuyProducts[index].isInterested = newState
                        popularBuyProducts[index].interestCount += newState ? 1 : -1
                    }
                }
            }
        }
    }
    
    private func getCurrentProductState(_ productId: Int, in section: ProductSection) -> ProductItemModel? {
        switch section {
        case .recommended:
            return recommendedProducts.first { $0.id == productId }
        case .popularSell:
            return popularSellProducts.first { $0.id == productId }
        case .popularBuy:
            return popularBuyProducts.first { $0.id == productId }
        }
    }
    
    private func updateProductInterestState(productId: Int, section: ProductSection, isInterested: Bool) {
        switch section {
        case .recommended:
            if let index = recommendedProducts.firstIndex(where: { $0.id == productId }) {
                recommendedProducts[index].isInterested = isInterested
            }
        case .popularSell:
            if let index = popularSellProducts.firstIndex(where: { $0.id == productId }) {
                popularSellProducts[index].isInterested = isInterested
            }
        case .popularBuy:
            if let index = popularBuyProducts.firstIndex(where: { $0.id == productId }) {
                popularBuyProducts[index].isInterested = isInterested
            }
        }
    }
    
    private func fetchBanners() {
        Task {
            loadingManager.startLoading()
            defer { loadingManager.stopLoading() }
            let result = await homeService.getBannerList()
            switch result {
            case .success(let response):
                if let dto = response.data,
                   let bannerModel = HomeBannersModel(dto: dto) {
                    self.banners = bannerModel
                } else {
                    logger.error("배너 데이터 없음 또는 변환 실패")
                }
                
            case .failure(let error):
                logger.error("fetchBanners failed: \(error.errorDescription ?? "Unknown error")")
            }
        }
    }
    
    private func fetchRecommendations() {
        Task {
            loadingManager.startLoading()
            defer { loadingManager.stopLoading() }
            let result = await homeService.getHomeRecommendations()
            switch result {
            case .success(let response):
                if let dtoList = response.data?.productRecommendList,
                   let username = response.data?.nickname {
                    self.originalUsername = username
                    self.recommendedProducts = dtoList.map { ProductItemModel(dto: $0) }
                }
            case .failure(let error):
                logger.error("fetchRecommendations failed: \(error.errorDescription ?? "Unknown error")")
            }
        }
    }
    
    private func fetchPopularSell() {
        Task {
            loadingManager.startLoading()
            defer { loadingManager.stopLoading() }
            let result = await homeService.getHomePopularSell()
            switch result {
            case .success(let response):
                if let dtoList = response.data?.productSellList {
                    self.popularSellProducts = dtoList.map { ProductItemModel(dto: $0) }
                }
            case .failure(let error):
                logger.error("fetchPopularSell failed: \(error.errorDescription ?? "Unknown error")")
            }
        }
    }
    
    private func fetchPopularBuy() {
        Task {
            loadingManager.startLoading()
            defer { loadingManager.stopLoading() }
            let result = await homeService.getHomePopularBuy()
            switch result {
            case .success(let response):
                if let dtoList = response.data?.productBuyList {
                    self.popularBuyProducts = dtoList.map { ProductItemModel(dto: $0) }
                }
            case .failure(let error):
                logger.error("fetchPopularBuy failed: \(error.errorDescription ?? "Unknown error")")
            }
        }
    }
}

// MARK: - Banner
extension HomeViewModel {
    private func requestOpenExternalURL(_ urlString: String) {
        externalURLToOpen = URL(string: urlString)
    }
}
