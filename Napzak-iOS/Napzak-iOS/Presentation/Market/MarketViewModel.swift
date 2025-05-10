//
//  MarketViewModel.swift
//  Napzak-iOS
//
//  Created by 어진 on 4/30/25.
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
    
    @Published var storeDetail: StoreDetailDTO?
    @Published var isLoadingProfile = false
    @Published var profileError: String? = nil
    
    @Published var products: [ProductItemModel] = []
    @Published var isLoadingProducts = false
    @Published var productsError: String? = nil
    @Published var productCount: Int = 0
    
    private let tabs = ["팔아요", "구해요", "리뷰"]
    private let storeService: StoreServiceProtocol
    private let productService: ProductServiceProtocol
    private var nextCursor: String? = nil
    
    init(storeService: StoreServiceProtocol = StoreService(), productService: ProductServiceProtocol = ProductService()) {
        self.storeService = storeService
        self.productService = productService
        fetchData()
    }
    
    func fetchData() {
        Task {
            await fetchStoreDetail()
        }
    }
    
    func canToggleInterestState(productID: Int) -> Bool {
        // TODO: - 좋아요 서버 통신 후 성공 여부 반환
        return true
    }
    
    func getProductCount() -> Int {
        return productCount
    }
    
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
                        let genreNameModels = genres.map { GenreNameModel(id: $0.genreId, name: $0.genreName) }
                        productFetchOption.genres = genreNameModels
                    }
                    
                    // 상점 정보를 가져온 후 상품 목록 조회
                    await fetchProductsWithStoreId(storeId)
                    
                case .failure(let error):
                    profileError = error.errorDescription
                }
            }
        case .failure(let error):
            profileError = error.errorDescription
        }
        
        isLoadingProfile = false
    }
    
    @MainActor
    private func fetchProductsWithStoreId(_ storeId: Int) async {
        await fetchProducts(storeId: storeId)
    }
    
    func fetchProducts() {
        Task {
            if let storeId = storeDetail?.storeId {
                await fetchProducts(storeId: storeId)
            }
        }
    }
    
    @MainActor
    private func fetchProducts(storeId: Int) async {
        isLoadingProducts = true
        productsError = nil
        
        // 장르 필터 설정
        let genreId = productFetchOption.genres.first?.id
        
        // 정렬 옵션 설정 - SortOption의 rawValue 직접 사용
        let sortOption = productFetchOption.sortOption.rawValue
        
        // 탭에 따라 다른 API 호출
        switch selectedTabIndex {
        case 0: // 팔아요 탭
            let result = await productService.fetchSellProducts(
                storeOwnerId: storeId,
                sort: sortOption,
                isOnSale: productFetchOption.isOnSale,
                isUnopened: productFetchOption.isUnopened,
                genreId: genreId,
                cursor: nextCursor
            )
            
            switch result {
            case .success(let response):
                self.nextCursor = response.nextCursor
                self.productCount = response.productCount
                
                // MarketProductItemDTO를 ProductItemModel로 변환
                self.products = response.productSellList.map { dto in
                    ProductItemModel(
                        id: dto.productId,
                        genreName: dto.genreName,
                        productName: dto.productName,
                        photo: dto.photo,
                        price: dto.price,
                        uploadTime: dto.uploadTime,
                        isInterested: dto.isInterested,
                        tradeType: .sell,
                        tradeStatus: TradeStatus(rawValue: dto.tradeStatus) ?? .beforeTrade,
                        isPriceNegotiable: nil,
                        isOwnedByCurrentUser: dto.isOwnedByCurrentUser,
                        interestCount: dto.interestCount,
                        chatCount: dto.chatInterest
                    )
                }
                
            case .failure(let error):
                productsError = error.errorDescription
            }
            
        case 1: // 구해요 탭
            let result = await productService.fetchBuyProducts(
                storeOwnerId: storeId,
                sort: sortOption,
                isOnSale: productFetchOption.isOnSale,
                genreId: genreId,
                cursor: nextCursor
            )
            
            switch result {
            case .success(let response):
                self.nextCursor = response.nextCursor
                self.productCount = response.productCount
                
                // MarketProductBuyItemDTO를 ProductItemModel로 변환
                self.products = response.productBuyList.map { dto in
                    ProductItemModel(
                        id: dto.productId,
                        genreName: dto.genreName,
                        productName: dto.productName,
                        photo: dto.photo,
                        price: dto.price,
                        uploadTime: dto.uploadTime,
                        isInterested: dto.isLiked,
                        tradeType: .buy,
                        tradeStatus: TradeStatus(rawValue: dto.tradeStatus) ?? .beforeTrade,
                        isPriceNegotiable: dto.isPriceNegotiable,
                        isOwnedByCurrentUser: dto.isOwnedByCurrentUser,
                        interestCount: dto.interestCount,
                        chatCount: dto.chatCount
                    )
                }
                
            case .failure(let error):
                productsError = error.errorDescription
            }
            
        default:
            break
        }
        
        isLoadingProducts = false
    }
}
