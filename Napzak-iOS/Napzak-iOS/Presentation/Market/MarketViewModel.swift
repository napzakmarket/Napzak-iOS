//
//  MarketViewModel.swift
//  Napzak-iOS
//
//  Created on 4/30/25.
//

import SwiftUI

final class MarketViewModel: ObservableObject {
    
    @Published var selectedTabIndex = 0
    @Published var productFetchOption = ProductFetchOption(sortOption: .recent, genres: [GenreNameModel](), isOnSale: false, isUnopened: false)
    @Published var dummyProducts: [ProductItemModel] = []
    
    private let tabs = ["팔아요", "구해요", "리뷰"]
    
    // MARK: - Init
    init() {
        fetchData()
    }
    
    func fetchData() {
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
    private func fetchProducts() {
        // 탭 인덱스에 따라 판매/구매 필터링 로직 추가 가능
        let isSelling = selectedTabIndex == 0
        
        // 실제 네트워크 요청 시 이 필터를 활용하여 API 요청 가능
        let _ = isSelling
        
        // 임시 데이터 로드
        dummyProducts = ProductItemModel.dummyProducts
    }
}
