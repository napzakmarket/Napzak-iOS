//
//  HomeViewModel.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/28/25.
//

import Foundation
import os

@MainActor
final class HomeViewModel: ObservableObject {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "HomeViewModel")
    
    @Published var banners: HomeBannersModel = .empty
    @Published var selectedBannerIndex: Int = 1
    @Published var timerPaused: Bool = false
    @Published var showLikeToast: Bool = false
    @Published var externalURLToOpen: URL?
    @Published var username: String = ""
    
    @Published var recommendedProducts: [ProductItemModel] = []
    @Published var popularSellProducts: [ProductItemModel] = []
    @Published var popularBuyProducts: [ProductItemModel] = []
    
    @Published var isBannersLoading: Bool = false
    @Published var isRecommendationsLoading: Bool = false
    @Published var isPopularSellLoading: Bool = false
    @Published var isPopularBuyLoading: Bool = false
    
    private let service = NetworkService.shared.homeService
    
    var recommendedTitle: String { "\(username)님을 위한 맞춤 PICK" }
    var recommendedSubtitle: String { "\(username)님의 취향에 딱 맞는 아이템들을 모아봤어요."}
    let popularSellTitle = "지금 가장 많이 찜한 납작템"
    let popularSellSubtitle = "놓치면 아쉬운 인기 아이템들을 구경해볼까요?"
    let popularBuyTitle = "다른 유저들은\n어떤 아이템을 찾고 있을까요?"
    let popularBuySubtitle = "놓치면 아쉬운 인기 아이템들을 구경해볼까요?"
    
    init() {
        fetchHomeData()
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
        
        // TODO: 다른 조건들 체크 (로그인 상태 등)
        guard let product = products.first(where: { $0.id == productID }) else { return false }
        return !product.isOwnedByCurrentUser
    }
    
    func toggleLike(for productId: Int, in section: ProductSection) {
        Task {
            print("toggleLike1")
            let currentState = getCurrentProductState(productId, in: section)
            let isAddingLike = (currentState?.isInterested ?? false)
            
            let success = await Task.detached(priority: .userInitiated) {
                // TODO: API 호출 (do catch?)
                
                return true
            }.value
            
            if success {
                if isAddingLike {
                    showLikeToast = true
                    try? await Task.sleep(for: .seconds(2))
                    showLikeToast = false
                }
            }
        }
    }
    
    func navigateToSellPopular() {
        // TODO: 탐색 > 팔아요 (인기순) 화면 이동
        print("navigateToSellPopular")
    }
    
    func navigateToBuyPopular() {
        // TODO: 탐색 > 구해요 (인기순) 화면 이동
        print("navigateToBuyPopular")
    }
}

extension HomeViewModel {
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
    
    private func fetchBanners() {
        Task {
            isBannersLoading = true
            defer { isBannersLoading = false }
            
            let result = await service.getBannerList()
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
            isRecommendationsLoading = true
            defer { isRecommendationsLoading = false }
            
            let result = await service.getHomeRecommendations()
            switch result {
            case .success(let response):
                if let dtoList = response.data?.productRecommendList,
                   let username = response.data?.nickname {
                    self.username = username
                    self.recommendedProducts = dtoList.map { ProductItemModel(dto: $0) }
                }
            case .failure(let error):
                logger.error("fetchRecommendations failed: \(error.errorDescription ?? "Unknown error")")
            }
        }
    }
    
    private func fetchPopularSell() {
        Task {
            isPopularSellLoading = true
            defer { isPopularSellLoading = false }
            
            let result = await service.getHomePopularSell()
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
            isPopularBuyLoading = true
            defer { isPopularBuyLoading = false }
            
            let result = await service.getHomePopularBuy()
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
