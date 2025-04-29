//
//  RegisterViewModel.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/29/25.
//

import SwiftUI

final class RegisterViewModel: ObservableObject {
    
    // MARK: - Property Wrappers
    
    @Published var model: RegisterModel = RegisterModel()
    @Published var normalDelivery: Bool = false                     // 일반 배달비 선택 여부
    @Published var halfDelivery: Bool = false                       // 알뜰,반값 배달비 선택 여부
    @Published var priceError: Bool = false

    let options = ["미개봉", "아주 좋은 상태", "약간의 사용감", "사용감 있음"]
    let maxPrice: Int = 1_000_000       // 최대 금액 100만원
    let normalMaxDeliveryCharge: Int = 30_000           // 일반 배달 최대 금액 3만원
    let halfMaxDeliveryCharge: Int = 5_000              // 반 값 배달 최대 금액 5000원
    let addPrices = ["+1,000원", "+5,000원", "+10,000원", "+100,000원"]


    //MARK: - Property Wrappers

    @Published var selectedTabIndex = 0
    @Published var productFetchOption = ProductFetchOption(sortOption: .recent, genres: [GenreName](), isOnSale: false, isUnopened: false)
    @Published var dummyProducts: [ProductItemModel] = []
    
    //MARK: - Init
    
    init() {
        fetchProducts()
    }

    //MARK: - Func
    
    func fetchProducts() {
        dummyProducts = ProductItemModel.dummyProducts
    }
    
    func canToggleInterestState(productID: Int) -> Bool {
        //TODO: - 좋아요 서버 통신 후 성공 여부 반환
        //통신 여부 뿐만 아니라 애초에 네트워크에 연결되어있는지 등도 함께 고려하면 좋을 듯
        return true
    }
    
}
