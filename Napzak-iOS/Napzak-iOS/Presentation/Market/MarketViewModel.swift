//
//  MarketViewModel.swift
//  Napzak-iOS
//
//  Created on 4/30/25.
//

import SwiftUI

final class MarketViewModel: ObservableObject {
    
    @Published var selectedTabIndex = 0
    @Published var productFetchOption = ProductFetchOption(
        sortOption: .recent,
        genres: [],
        isOnSale: false,
        isUnopened: false
    )
    @Published var dummyProducts: [ProductItemModel] = []
    
    // Add store profile data
    @Published var storeDetail: StoreDetailDTO?
    @Published var isLoadingProfile = false
    @Published var profileError: String? = nil
    
    private let tabs = ["팔아요", "구해요", "리뷰"]
    private let storeService: StoreServiceProtocol
    
    // MARK: - Init
    init(storeService: StoreServiceProtocol = StoreService()) {
        self.storeService = storeService
        fetchData()
    }
    
    func fetchData() {
        Task {
            await fetchStoreDetail()
        }
        
        switch selectedTabIndex {
        case 0, 1: // 팔아요, 구해요 탭
            fetchProducts()
        case 2: // 리뷰 탭
            // 리뷰는 아직 구현 안함
            break
        default:
            break
        }
    }
    
    func canToggleInterestState(productID: Int) -> Bool {
        // TODO: - 좋아요 서버 통신 후 성공 여부 반환
        return true
    }
    
    func getProductCount() -> Int {
        return dummyProducts.count
    }
    
    // MARK: - Private Methods
    @MainActor
    private func fetchStoreDetail() async {
        isLoadingProfile = true
        profileError = nil
        
        // MyPage info (본인 상점 정보) 가져옴
        let result = await storeService.getMyPageInfo()
        
        switch result {
        case .success(let response):
            if let storeId = response.data?.storeId {
                // storeId로 상점 상세 정보 가져옴
                let detailResult = await storeService.getStoreDetail(storeId: storeId)
                
                switch detailResult {
                case .success(let detailResponse):
                    storeDetail = detailResponse.data
                    if let genres = detailResponse.data?.genrePreferenceList {
                        // Convert GenreDTO to GenreNameModel for the filter
                        let genreNameModels = genres.map { GenreNameModel(id: $0.genreId, name: $0.genreName) }
                        productFetchOption.genres = genreNameModels
                    }
                case .failure(let error):
                    profileError = error.errorDescription
                }
            }
        case .failure(let error):
            profileError = error.errorDescription
        }
        
        isLoadingProfile = false
    }
    
    private func fetchProducts() {
        // 탭 인덱스에 따라 판매/구매 필터링 로직 추가 가능
        let isSelling = selectedTabIndex == 0
        
        // 실제 네트워크 요청 시 이 필터를 활용하여 API 요청 가능
        _ = isSelling
        
        // 임시 데이터 로드 (상품 목록 API 연결은 이후 작업)
        dummyProducts = ProductItemModel.dummyProducts
    }
}
