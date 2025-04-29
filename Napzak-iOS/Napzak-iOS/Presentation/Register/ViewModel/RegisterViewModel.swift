//
//  RegisterViewModel.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/29/25.
//

import SwiftUI

final class RegisterViewModel: ObservableObject {
    @Published var path: [RegisterRoute] = []
    
    // MARK: - Property Wrappers
    
    @Published var model: RegisterModel = RegisterModel()
    @Published var normalDelivery: Bool = false                     // 일반 배달비 선택 여부
    @Published var halfDelivery: Bool = false                       // 알뜰,반값 배달비 선택 여부
    @Published var priceError: Bool = false
    
    @Published var genreSearchText = ""
    @Published var isCompleted: Bool = false
    @Published var genreList: [GenreName] = [GenreName(id: 1, name: "나루토"),
                                                 GenreName(id: 2, name: "원피스"),
                                                 GenreName(id: 3, name: "드래곤볼"),
                                                 GenreName(id: 4, name: "명탐정 코난"),
                                                 GenreName(id: 5, name: "진격의 거인"),
                                                 GenreName(id: 6, name: "슬램덩크")]
    
    

    let options = ["미개봉", "아주 좋은 상태", "약간의 사용감", "사용감 있음"]
    let maxPrice: Int = 1_000_000       // 최대 금액 100만원
    let normalMaxDeliveryCharge: Int = 30_000           // 일반 배달 최대 금액 3만원
    let halfMaxDeliveryCharge: Int = 5_000              // 반 값 배달 최대 금액 5000원
    let addPrices = ["+1,000원", "+5,000원", "+10,000원", "+100,000원"]

    
}
