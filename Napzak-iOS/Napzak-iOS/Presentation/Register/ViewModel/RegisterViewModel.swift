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
    @Published var maxPrice: Int = 1_000_000       // 최대 금액 100만원
    @Published var addPrices = ["+1,000원", "+5,000원", "+10,000원", "+100,000원"]

}
