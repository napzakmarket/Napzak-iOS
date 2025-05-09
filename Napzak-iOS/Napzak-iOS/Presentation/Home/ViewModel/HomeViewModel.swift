//
//  HomeViewModel.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/28/25.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var banners: HomeBannersModel
    @Published var selectedBannerIndex: Int = 1
    @Published var timerPaused: Bool = false
    @Published var showLikeToast: Bool = false
    @Published var externalURLToOpen: URL?
   
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var username: String = ""
    
    @Published var recommendedProducts: [ProductItemModel] = []
    @Published var popularSellProducts: [ProductItemModel] = []
    @Published var popularBuyProducts: [ProductItemModel] = []
    
    var recommendedTitle: String { "\(username)님을 위한 맞춤 PICK" }
    var recommendedSubtitle: String { "\(username)님의 취향에 딱 맞는 아이템들을 모아봤어요."}
    let popularSellTitle = "지금 가장 많이 찜한 납작템"
    let popularSellSubtitle = "놓치면 아쉬운 인기 아이템들을 구경해볼까요?"
    let popularBuyTitle = "다른 유저들은\n어떤 아이템을 찾고 있을까요?"
    let popularBuySubtitle = "놓치면 아쉬운 인기 아이템들을 구경해볼까요?"
    
    init() {
        self.banners = HomeBannersModel.sample
        fetchHomeData()
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
    private func fetchHomeData() {
        self.username = "납자기"
        self.recommendedProducts = ProductItemModel.dummyProducts
        self.popularSellProducts = ProductItemModel.dummyProducts
        self.popularBuyProducts = ProductItemModel.dummyProducts
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
}

// MARK: - Banner
extension HomeViewModel {
    private func requestOpenExternalURL(_ urlString: String) {
        externalURLToOpen = URL(string: urlString)
    }
}
